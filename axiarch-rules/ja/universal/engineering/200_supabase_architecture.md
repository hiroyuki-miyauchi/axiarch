# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-07-23

> [!IMPORTANT]
> **Primary Directive（主要方針）**
> 「データは企業の血液である。その流れと保護に一切の妥協は許されない。」
> Supabase/PostgreSQLの実装において、**セキュリティ(RLS) > データ整合性 > パフォーマンス > 開発生産性 > コスト効率** の優先順位を厳守せよ。
> この文書は、Supabase/PostgreSQLを採用したシステムにおけるバックエンド・データ戦略のプロバイダープロファイルである。
> **60セクション・200+ルール構成。**

> [!NOTE]
> **Universal適用契約**
> 本ファイルはSupabase/PostgreSQLの採用を全プロジェクトへ強制しない。採用判断は `engineering/520_cloud_application_platforms.md` の能力・リスク・コスト・可搬性評価に従い、採用した機能に該当する規則だけを適用する。製品名、上限、CLI、既定値、ファイルパス、framework helper、固定thresholdは参照例であり、実装時に公式文書と実効設定を再確認する。固定トポロジー、固定リージョン、固定予算、固有の命名はBlueprintへ配置する。本profile内の具体的recipeと、least privilege、data integrity、migration immutability、520の横断原則が競合する場合は後者を優先し、recipeをそのまま強制しない。

---

## 目次

- §0. データ主権法と主要方針 (Primary Directives)
- §1. Supabase ハイブリッドスタック原則
- §2. Database Design Standards (DB設計基準)
- §3. Integrity & Logic Strategy (整合性・ロジック戦略)
- §4. Performance & Scalability (パフォーマンス)
- §5. Auth & Security (認証・セキュリティ)
- §6. Storage & Delivery (ストレージ・配信)
- §7. Operations & Migration (運用・マイグレーション)
- §8. Maintenance & Hardening (保守・堅牢化)
- §9. Domain Data Modeling (ドメインデータモデリング)
- §10. Universal Portability (ポータビリティ)
- §11. Backend Governance (バックエンドガバナンス)
- §12. Migrations & Privileged Operations (マイグレーション特権操作)
- §13. Edge Functions アーキテクチャ
- §14. Realtime エンジン
- §15. Cron・Queue・Webhook 戦略
- §16. Observability & FinOps
- §17. pgvector & AI Search
- §18. Advanced Auth & API Key 管理
- §19. Testing 戦略
- §20. Branching & 環境管理
- §21. PostgREST / REST API 最適化
- §22. CLI & ローカル開発
- §23. Connection Pooling (Supavisor)
- §24. Backup & DR 戦略
- §25. Rate Limiting & API Protection
- §26. Vault & Secret 管理
- §27. Foreign Data Wrappers (FDW)
- §28. Data API Hardening
- §29. Multi-tenancy 戦略
- §30. pg_graphql / GraphQL
- §31. DB Functions & Triggers
- §32. Log Drain & External Observability
- §33. Auth Hooks & Custom Claims
- §34. Self-hosted & Email 設定
- §35. SSR / フレームワーク統合
- §36. Database Extensions 管理
- §37. Client SDK / supabase-js
- §38. Schema Design Patterns
- §39. Social Auth / OAuth / SSO
- §40. Data Migration & Seeding
- §41. Multigres & 水平スケーリング
- §42. PostgreSQL 18 新機能 (AIO・UUIDv7・Skip Scan)
- §43. Column-Level Security
- §44. Passkeys & Biometric Auth
- §45. MCP Server & AI開発統合
- §46. Security Advisor & 自動修復
- §47. テーブル別API制御 & Data API無効化
- §48. VPC & Private Link
- §49. Read Replicas & 負荷分散
- §50. Project-scoped Roles & チーム管理
- §51. Provider-neutral CI/CD
- §52. Advisory Locks & 同時実行制御
- §53. Webhook署名検証 & イベント駆動統合
- §54. Database Partitioning 高度戦略
- §55. Full-Text Search & pg_trgm
- §56. AI Assistant & 生成SQL管理
- §57. 型安全エンドツーエンド
- §58. グローバルCDN & Edge Caching
- §59. コンプライアンス & データ主権
- §60. 運用成熟度モデル
- Appendix A: サービス別逆引き索引
- Appendix B: クロスリファレンス

---

## 0. データ主権法と主要方針 (Data Sovereignty Law & Primary Directives)

### Primary Directive 0.1: The Zero Tolerance Linter Protocol
-   **Law**: Database Linter（Supabase Security Advisor等）の警告は、未検証のまま無視せず、セキュリティ・整合性・性能上のリスクとしてトリアージします。
-   **Mandate**:
    1.  **Risk-Based Gate**: 適用可能なCritical/High所見、または安全性を説明できない所見が残る場合はリリースを停止します。
    2.  **Documented Disposition**: 誤検知、非適用、期限付き受容は、根拠・影響・所有者・承認者・失効日を記録します。個別所見を検証せずに一括抑制してはなりません。

### Primary Directive 0.2: The Trinity DTO Mandate
-   **Purpose**: データ構造の堅牢性とスケーラビリティを支えるための三位一体の義務。
    -   **Security**: ホワイトリスト出力により、生データ流出リスクを低減する。
    -   **Stability**: DB変更からフロントエンドを守る (Mapper Shield)。
    -   **AI Economy**: AIトークンを節約する (Data Minimization)。
    -   **Universality**: 言語を問わないエンジニアリングの基盤標準です。

### Primary Directive 0.3: Omnichannel Data Principle (API First)
-   **Principle**: データ構造は、単一のWebアプリだけでなく、ネイティブアプリ、外部システム、AIエージェントからも消費されることを前提に設計しなければなりません。
-   **Mandate**:
    -   **Universal Types**: 特定のUIフレームワークに依存したデータ型（React Nodeなど）をDBに保存してはなりません。
    -   **Neutral JSON**: JSONデータは、表示ロジックを含まない「純粋なデータ」として管理してください。

### Primary Directive 0.4: The Client DTO Barrier（クライアントDTO障壁）
-   **Law**: データベースの行データ（Raw Entity）を、クライアントサイドコンポーネント（`use client` 等）のPropsとして**直接渡すことを禁止**します。
-   **Mandate**:
    -   **Server-Side Transformation**: 必ずサーバー側で目的に応じた軽量なDTOへ変換し、必要最小限のフィールドのみをクライアントへ送信してください。
    -   **PII Exclusion**: `admin_notes`, `phone_number`, `email` 等のPIIや内部管理フィールド（`deleted_at`, `internal_memo`）がブラウザへ到達するリスクを設計上低減してください。
    -   **Payload Minimization**: 不要なフィールドの送信は、ネットワーク帯域の浪費と、将来のデータ漏洩リスクの二重の問題を引き起こします。
-   **Rationale**: SD 0.2（Trinity DTO Mandate）が定義するDTO化義務の具体的な境界線として、クライアントコンポーネントへのデータ受け渡しを物理的な遮断点として確立します。Raw Entityの直接送信は、意図しないPII漏洩の最大のリスク源です。

### Core Laws
-   **Explicit Authority (Single Source of Truth)**: データ領域ごとに権威ある保存先と所有者を一つ定義します。PostgreSQL、外部CMS、オブジェクトストレージ、構成リポジトリ等の併用は、領域境界・同期方向・競合解決・障害時挙動が明文化されている場合に許可します。意図しない二重権威は禁止します。
-   **Migration Only**: DBスキーマ変更は、リポジトリで管理されたプロバイダー標準のマイグレーション経由で行います。`supabase/migrations` は標準的な例です。緊急手動操作は事前承認またはbreak-glass手順、監査証跡、直後のコード化・差分照合を必須とします。
-   **Migration Immutability Law (Sanctuary)**:
    -   **Law**: 共有環境へ適用済み、または他者が依存するマイグレーションは不変とし、修正は新規マイグレーションで行います。
    -   **Private Draft**: 未適用かつ作成者だけが保持するドラフトは、レビュー前に限り履歴を明確に保って修正できます。

---

## 1. ハイブリッドスタック責務 (Hybrid Stack Responsibility)
-   **Capability-Based Stack**:
    -   **Edge/CDN**: DDoS防御、WAF、キャッシュ、ルーティング、軽量な低遅延処理を、採用基盤の実行制限とデータ境界に合わせて配置します。Cloudflareは選択肢の一つです。
    -   **Frontend/Application Platform**: UIレンダリング、API、バックグラウンド処理を、レイテンシ、実行時間、状態、可観測性、コストに応じて配置します。Vercelは選択肢の一つです。
    -   **Data Platform**: DB、Auth、Storage、Realtime、非同期処理を、権威データ境界と復旧要件に合わせて配置します。Supabaseは選択肢の一つです。
    -   **Boundary Contract**: 複数基盤を併用するときは、データ所有権、認証主体、ネットワーク経路、再試行、整合性、障害時縮退、コスト帰属を明示します。

---

## 2. データベース設計基準 (Database Design Standards)

### Rule 2.0: The Realism Mandate (Anti-Haribote Protocol)
-   **Prohibition**: 永続化、整合性、検索可能性、権威data sourceが存在しない値を、保存・検証済みのdomain dataであるかのようにUIやAPIで表現してはなりません。
-   **Requirement**: 財務、権限、状態遷移等の重要属性は、relational column、versioned JSON schema、別のauthoritative store等から、query、constraint、concurrency、retention、migration要件に適合する表現を選び、型・制約・ownerをdata contractへ記録します。
-   **Delivery Contract**: UI、API、storage、migrationをbackward-compatibleな順序でdeliveryし、旧clientとの共存期間を検証します。一つのatomic releaseを一律要求しません。

### Rule 2.0.1: The Settings Representation Architecture
-   **Law**: 設定はaccess pattern、constraint、更新単位、検索、履歴、schema evolutionから表現を選びます。独立してquery・join・制約・権限管理する属性はrelational column／tableを優先し、一つのbounded aggregateとして読み書きする可変構造はJSONBを選べます。
-   **JSONB Contract**: JSONBにはowner、versioned schema、runtime validation、size limit、default、unknown-field policy、migration／backfill、index方針を定義します。型なしのcatch-all blob、無制限成長、秘密情報の混在は禁止します。
-   **Promotion Trigger**: 頻繁なfilter／join、強いDB constraint、field-level authorization、独立lifecycle、hot-update contentionが必要になった属性はcolumnまたは関連tableへ昇格します。
-   **Migration**: relational schemaまたはJSON contractのbreaking changeはmigrationとしてversion管理し、old/new reader互換、backfill、rollback／forward-fixを検証します。

### Rule 2.1: Integrity & Ownership
-   **RLS Strict Default**: exposed schemaとuntrusted client accessでは行レベルセキュリティ（RLS）を標準境界とします。`service_role`等のbypass credentialはclientへ渡さず、server-sideの限定workloadだけに最小scope、監査、rotationを伴って許可します。maintenance、migration、system jobまでRLS経由へ一律強制せず、各privileged pathの認可境界を明示します。
-   **Hierarchical Resource Ownership (階層的リソース所有権)**:
    -   **Context**: 家族共有、チームプロジェクトなど、単一所有者（`user_id`）では表現できない複雑な所有権構造。
    -   **Law**: 複数principalがresourceへアクセスする場合、membership table、relationship graph、tenant claim、policy service等から、更新頻度、consistency、revocation、query costに合うauthoritative authorization modelを選び、RLSまたはserver boundaryで強制します。
    -   **Action**:
        1.  **Authority**: owner、member、role、tenant、delegationの正本と更新者を明示する。
        2.  **Revocation**: 失効がcache、JWT、replicaへ反映される上限を定義する。
        3.  **Inheritance**: 親子継承を使う場合は循環、越境、confused deputy、削除時挙動をnegative testする。
-   **PII Encryption**: data classificationとthreat modelに応じて、provider encryption、application／field-level encryption、tokenization等を選び、key ownership、rotation、searchability、backup／restoreを設計します。Vaultやpgcryptoは候補であり一律既定ではありません。

### Rule 2.2: Schema & Type Standards
-   **Schema Separation**: exposed API、internal data、extension object、audit／administrationのtrust boundaryをschemaとgrantで分離します。schema名を`public`／`extensions`／`admin`へ固定せず、既存extension locationとprovider supportを確認してmigrationします。
-   **Managed Schema Boundary**: `storage`、`auth`、`graphql`等のprovider-managed schemaは、公式extension pointまたは検証済みmigration以外で直接変更しません。参照が必要な場合もupgrade互換性と権限をtestします。
-   **Constraints**:
    -   **Identity**: key typeはglobal uniqueness、sortability、offline生成、replication、privacy、storage costから選びます。連番が適合する場合は`IDENTITY`を`SERIAL`より優先します。
    -   **Money**: exactな金額・会計計算にはsmallest-unit integerまたは精度・丸めを明示した`numeric`／`decimal`を用います。近似値が許容される測定値までfloatを禁止しません。
    -   **Boolean**: `NULL`が未知／未評価としてdomain上必要かを決めます。二値なら`NOT NULL`と意図したdefault、三値なら意味・query・migrationをdata contractへ記録します。

### Rule 2.3: Type Safety Protocol (The Bridge)
-   **Generated Contract**: 採用SDK／言語で公式生成が利用可能なら、schema revisionから型またはclient contractを再現可能に生成し、生成元digestとdriftをCIで検証します。TypeScriptの`database.types.ts`は一例です。
-   **Boundary Validation**: compile-time typeだけに依存せず、untrusted input、database result、event、external APIを言語nativeまたは承認済みruntime validatorで検証します。
-   **Adapter Law**: generated typeをdomain typeへ変換するadapterはnullability、decimal、timestamp、enum未知値、JSON、64-bit integerを明示します。Mapped Type、intersection、class、code generation等のHowを一律禁止・強制せず、type testとruntime testで安全性を証明します。

### Rule 2.4: The New Table Checklist (Creation Protocol)
-   **Law**: 新規テーブルは適用項目を満たし、非該当項目は理由を記録します。
    - [ ] **Exposure & Grants**: exposed schemaかを明示し、roleごとのtable／column privilegeを最小化したか？
    - [ ] **RLS & Policy**: exposed schemaまたはuntrusted client pathではRLSを有効化し、必要な`anon`／`authenticated`等の操作だけをpositive／negative testしたか？ RLS bypass roleへ冗長なpolicyを作成しない。
    - [ ] **Integrity & Index**: PK、FK、unique、check、nullabilityと、実query／join／delete costに必要なindexを確認したか？ 全FKへの機械的一律indexを前提にしない。
    - [ ] **Contract**: 採用言語のgenerated type／schema client／API contractを更新し、driftを検証したか？
    - [ ] **Lifecycle & Audit**: retention、deletion、backup、replication、PII、監査要件を分類し、必要なtableだけへaudit mechanismを適用したか？

### Rule 2.17: The Schema-Reality Reconciliation Checklist（スキーマ現実突合チェックリスト）
-   **Law**: データアクセスコード（Query/Mutation/DTO）を新規作成・変更する際は、参照する全カラムが実際のDBスキーマに存在し、型・制約が一致することを事前に検証しなければなりません。
-   **Action**:
    1.  **Column Existence**: `.select('column_name')` や `.not('column', 'is', null)` を書く前に、自動生成型定義ファイル（`database.types.ts` 等）の `Row` 型で**カラムの実在を確認**してください。「たぶん存在する」は禁止です。
    2.  **FK Name Verification**: 外部キー名（`user_id`, `owner_id` 等）はテーブルごとに異なります。デフォルト名を仮定せず、各テーブルの実際のFK名を型定義で確認してください。
    3.  **RPC vs Column Distinction**: RPC関数（例: `get_point_balance`）はカラムではありません。`.select()` で直接取得できないため、元テーブルからの集計やRPC呼び出しとして正しく実装してください。
    4.  **Array Empty Check**: 配列型カラム（`text[]`, `jsonb[]` 等）の「存在チェック」は `.not('column', 'is', null)` だけでは不十分です。空配列 `{}` も除外するために `.neq('column', '{}')` を追加してください。
    5.  **Nullable Parity**: DBで `nullable` なカラムは、TypeScriptの型定義でも `optional (?)` または `| null` で定義してください。自動生成型との乖離は「将来のランタイムエラー」の入り口です。
-   **Checklist（新規バックエンド実装時）**:
    | チェック項目 | 確認方法 |
    |---|---|
    | 全参照カラムが型定義ファイルに存在する | Row型の目視確認 |
    | RPC関数をカラムとして扱っていない | Functions セクションとの突合 |
    | FK名が実テーブル定義と一致する | Relationships セクションの確認 |
    | 配列型カラムの空チェックが正しい | `.neq('column', '{}')` の追加 |
    | nullable/optional が DB定義と一致する | 自動生成型との突合 |
-   **Rationale**: スキーマと実装の乖離（Schema-Reality Gap）は、本番環境でのみ顕在化する「サイレントバグ」の主因です。型定義ファイルを「絶対的な真実」として扱い、推測による実装を排除することで、この種のバグをゼロにします。

### Rule 2.18: The Automated Data Retention Protocol（自動データ保持期間プロトコル）
-   **Law**: 時間経過とともに蓄積されるデータには、**カテゴリ別の保持期間**を定義し、期限到達後に**自動的にパージまたは匿名化**する仕組み（Cron Job / Scheduled Task）を実装しなければなりません。
-   **Action**:
    1.  **Retention Category Definition**: 全データ集合を目的、法的根拠、data subject、sensitivity、復旧要件で分類し、legal／privacy／security／business ownerが保持・削除条件を承認します。次表の期間は構造を示す例であり、Universal既定値ではありません。
        | カテゴリ | 例 | Blueprintで決める保持条件の例 |
        |---|---|---|
        | アクティブデータ | ユーザー、コンテンツ | 無期限（退会まで） |
        | トランザクションログ | 決済記録 | 法定保持期間（例: 7年） |
        | アクセスログ | リクエストログ、トレース | 90日 |
        | セッションデータ | セッション、トークン | 30日 |
        | 一時データ | OTPコード、アップロード一時ファイル | 24時間 |
        | 分析データ | アナリティクスイベント | 2年（集約後サマリーへ） |
    2.  **Automated Purge**: `pg_cron` やクラウドスケジューラ等を使用し、保持期限を超過したデータを自動的に削除・アーカイブするバッチジョブを実装してください。
    3.  **Account Deletion Lifecycle**: 退会、legal hold、fraud prevention、contract termination、DSARに対し、非公開化、access revocation、grace period、物理削除／匿名化を期限と例外付きで定義します。
    4.  **Purge Logging**: パージ実行の記録（対象テーブル、削除件数、実行日時）を監査ログに残してください。
-   **Rationale**: データを無期限に保持することは、ストレージコストの増大、プライバシーリスクの拡大、そしてGDPR/APPI等のデータ最小化原則への違反を招きます。保持期間の自動管理により、コスト・コンプライアンス・パフォーマンスの三方良しをもたらします。

---

## 3. インテグリティとロジック戦略 (Integrity & Logic Strategy)

### Primary Directive 3.0: The RLS Implementation Iron Rules
-   **Law 1: Atomic Action Definition**
    -   `FOR INSERT, UPDATE` のようなカンマ区切り定義は禁止。`FOR ALL` 以外は、必ず**アクションごとに個別のポリシー**として定義してください。
-   **Law 2: INSERT Syntax Discipline**
    -   `INSERT` ポリシーは必ず **`WITH CHECK`** を使用してください（`USING` は不可）。
-   **Law 3: Zero Guessing Protocol**
    -   SQL作成前には必ずスキーマ定義ファイルを読み込み、**カラム名を指差し確認**してください。推測による実装は厳禁です。
-   **Law 4: Performance Safety (Scalar Subquery Mandate)**
    -   **Law**: `auth.uid()`等のstable helperは、公式推奨と実行計画がInitPlan化の利益を示す場合に`(select auth.uid())`形式を用います。他table参照を無条件にscalar subqueryへ包まず、correlation、cardinality、index、policy semanticsを保持します。
    -   **Evidence**: representative dataとroleで`EXPLAIN`、policy test、latency／CPUを比較し、optimizationが認可結果を変えないことを検証します。

### Rule 3.0.1: The RLS Helper Functions Registry (RLS Utility)
-   **Helper Isolation**: RLS ポリシー内で対象テーブルを再参照すると無限再帰（`42P17`）が発生し得ます。複雑な認可は、まず `SECURITY INVOKER`、security-barrier view、claim、または単純化したpolicyで解決し、所有者権限が本当に必要な最小境界だけを `SECURITY DEFINER` 関数へ分離してください。
-   **The Qualified Schema Mandate (RPC Security)**:
-   **Law**: `SECURITY DEFINER`はprivilege boundaryとして扱い、安全な`search_path`、schema完全修飾、最小`EXECUTE` grant、入力validation、negative testを必須とする。`SET search_path = ''`を選ぶ場合はbuilt-inを含む参照を完全修飾し、利用extensionとの互換性をtestする。
-   **Registry Standards**:
        -   helper名、引数、返却、owner、volatility、security mode、利用policyをinventory化する。
        -   `is_admin()`や`is_owner(resource_id)`は例であり、固定schema、role名、関数名をUniversalへ持ち込まない。
        -   **Requirement**: ヘルパー関数は `SECURITY INVOKER` を既定とします。`SECURITY DEFINER` を採用する場合は、権限昇格が必要な理由、返却可能な情報、呼び出し可能role、RLS迂回範囲をレビューし、`SET search_path = ''`、完全修飾参照、`PUBLIC`からの`EXECUTE`取消、許可roleへの明示grant、負の権限テストを必須とします。

### Rule 3.0.2: The Privileged Access RLS Protocol
-   **Context**: 運用者による訂正が必要なデータでも、全policyへ恒久的な管理者バイパスを追加すると、侵害時の影響と内部不正の範囲が全データへ拡大します。
-   **Law**: privileged accessは通常のuser pathから分離し、対象resource、action、reason、時間、環境を最小化します。管理者例外は業務要件があるpolicyにだけ明示し、既定deny、step-up認証、監査、承認またはbreak-glass、失効を備えます。
-   **Illustrative Pattern**:
    ```sql
    -- このresourceで承認済みoperator updateが必要な場合だけ追加する
    ON public.posts
    FOR UPDATE
    TO authenticated
    USING (
      (user_id = (select auth.uid()) AND ...)  -- 一般ユーザー条件
      OR
      (select private.can_operate_post((select auth.uid()), id))
    );
    ```
    ※ helperを`SECURITY DEFINER`にする場合はRule 3.0.1の制約を適用し、role名だけでなくtenant、resource、action、失効時刻を検証してください。

### Rule 3.0.3: The RLS Recipes (Implementation Standards)
-   **Non-Normative Examples**: 次のSQLはpolicy構文の例であり、`profiles`、role名、1時間、親子schemaを採用要件にしない。実装前にactor、tenant、resource、operation、time、revocation、indexをdata contractから導出する。
-   **Admin Only Write (Strict Lock)**:
    ```sql
    -- "admins_only_insert_policy"
    FOR INSERT WITH CHECK (
      EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = (select auth.uid()) AND role IN ('admin', 'super_admin')
      )
    );
    ```
-   **User Restricted (Owners - Time Limited)**:
    ```sql
    -- "users_update_own_posts_policy"
    FOR UPDATE USING (
      user_id = (select auth.uid())      -- 本人のみ
      AND created_at > (now() - interval '1 hour') -- 作成後1時間以内のみ
    );
    ```
-   **Heirarchical Access (Parent Check)**:
    ```sql
    -- "child_resource_select_policy"
    FOR SELECT USING (
      EXISTS (
        SELECT 1 FROM public.parents
        WHERE id = child_table.parent_id
        AND (owner_id = (select auth.uid()) OR is_public = true)
      )
    );
    ```
### Rule 3.1: RLS Separation of Duties
-   **Separation Protocol**:
    1.  **Select Policy**: 読み取り権限は `FOR SELECT` 専用ポリシーで管理。
    2.  **Write Policy**: `INSERT`、`UPDATE`、`DELETE`はそれぞれの`USING`／`WITH CHECK` semanticsとread-back要件を明示する。`FOR ALL`は同一条件が全commandへ本当に適合し、negative testで証明できる場合だけ使う。
-   **Privileged Strictness**: 「管理者だから全部OK」の恒久的なbroad policyを避け、resource／operation／tenant／timeを限定する。

### Rule 3.2: Permissive Policy Consolidation
-   **Semantics First**: 複数`PERMISSIVE` policyが`OR`、`RESTRICTIVE` policyが追加制約として働くことを前提に、role、command、owner、監査性、実行計画を比較する。論理的に重複するpolicyは除去するが、異なるrole／責任を可読性のため分離する設計を一律統合しない。
-   **Evidence**: 変更前後のeffective accessをpositive／negative／cross-tenant testで比較し、代表queryのplanで性能改善を確認する。

### Rule 3.3: Data Integrity Patterns
-   **Lifecycle Choice**: hard delete、soft delete、tombstone、anonymization、legal holdをdata category、復元、監査、privacy deletion、unique semanticsから選ぶ。`deleted_at`とpartial unique indexは候補であり、主要dataへ一律強制しない。
-   **The Right to be Forgotten (Soft Delete Exception)**:
    -   **Context**: 原則は論理削除ですが、ユーザーからの明示的な「アカウント削除リクエスト」および GDPR/Apple 要件に対しては、物理削除または完全匿名化（PII抹消）を行う義務があります。
    -   **Action**: 退会処理においては `deleted_at` だけでなく、個人特定情報を物理的に削除するか、不可逆的にマスク (`deleted_user_xyz`) してください。
    -   **Representation Update**: 複数表現を持つ場合はauthoritative representation、derived representation、generation version、atomic update／rebuild、drift detectionを定義する。
    -   **Structured Migration**: JSON変更はversioned schemaとparser／migrationで行い、構造を無視した文字列置換は避ける。

### Rule 3.3.1: The CMS Triple Write Protocol (Search Consistency)
-   **Context**: CMSや検索ではauthoring、rendering、sorting、search representationが異なる場合がある。
-   **Law**: 正本を1つ定義し、追加表現は測定されたquery／locale要件がある場合だけderived dataとして生成する。固定3カラム、かな表記、n-gramを全domainへ強制しない。
-   **Synchronization**: generated column、trigger、pipeline、application transactionの候補から、atomicity、rebuild、versioning、failure recoveryに合う方式を選び、driftを検知する。

### Rule 3.3.2: The Multiple Permissive Policies Conflict (Policy Hygiene)
-   **Law**: 同一commandの`PERMISSIVE` policyは`OR`で結合されるため、個々のpolicyだけでなくcombined effective accessをreviewする。複数policy自体を脆弱性と断定しない。
-   **Action**: 既存policy inventoryと依存consumerを確認し、重複・shadowed・過剰許可だけを同一migrationで修正する。安全性を証明せず先に`DROP`して可用性を壊してはならない。
-   **Verification**: `pg_policies`等のmachine-readable inventory、role別positive／negative test、representative plan、rollbackをevidenceにする。policy数に固定targetを置かない。

### Rule 3.4: RLS Lifecycle Management Protocol
-   **Create-Verify-Retire**:
    1.  **Before Change**: policy、role、grant、bypass identity、consumerをinventoryし、期待するeffective accessをtest case化する。
    2.  **Apply Safely**: transactional DDLの可否とlockを確認し、過剰許可windowと正規access遮断の双方を避けるexpand／contract順序を選ぶ。
    3.  **After Change**: provider advisor、catalog diff、role別test、application flow、query planを確認し、旧policyは依存が消えた証拠を得てretireする。
-   **Naming Convention**: teamが一意性、table、command、intentを識別できるversioned conventionをBlueprintで決める。自然言語名や特定formatをUniversalで禁止・固定しない。
-   **Rollback**: policy変更とrollbackはimmutable migrationで管理し、policy名をcatalogから解決して意図しない対象を変更しない。
-   **Change Checklist**: catalogから取得したpolicy identifierと定義、期待するeffective access、依存consumer、migration順序、rollback、advisor所見をmachine-readable evidenceへ残す。入力方法やpolicy数ではなく、識別子の正確性と検証結果をgateにする。
-   **Strictification Guardrail**: 緩い`PERMISSIVE` policyが残れば厳格policy追加だけではeffective accessを狭められない。transaction、lock、availability、rollbackを評価し、旧policyのreplace／dropと新policyの作成を、過剰許可windowを生まない順序で実施する。

### Rule 3.5: Public Read Protocol (Anti-Vault Paradox)
-   **Principle**: 「セキュリティ」とは機能不全にすることではない。
-   **Law**:
    1.  **Public Read**: 明示的にpublic分類したdataだけを、field minimization、scraping／abuse、cache、rate、future schema evolutionを評価して公開する。`USING (true)`は意図した全row公開契約とnegative testがある場合の候補である。
    2.  **Strict Write**: 書き込み（`INSERT/UPDATE/DELETE`）は引き続き厳格にロック。
    3.  **Separation**: readとwriteのactor、row、column、rateを別contractとしてtestする。

---

## 4. パフォーマンスとスケーラビリティ (Performance & Scalability)

### Rule 4.1: Indexing Hygiene Protocol
-   **FK Indexing**: FKのindexはjoin、parent update／delete、cardinality、write amplification、table size、query planから判断する。全FKへ一律作成せず、必要なcomposite／partial indexを実queryから設計する。
-   **Naming Convention**: index名は一意性、table、column／expression、predicateを追跡できるproject conventionで管理する。`idx_<table>_<column>`は例である。
-   **Lifecycle**: usage statistic、query plan、write cost、constraint support、seasonal traffic、standby／replicaを十分な観測期間で評価し、作成・reindex・削除をonline impactとrollback付きで行う。

### Rule 4.2: Japanese Search Optimization
-   locale、tokenization、typo tolerance、ranking、highlight、update latency、extension supportを評価し、PostgreSQL native FTS、`pg_trgm`、PGroonga、外部search等を選ぶ。CJK対応を単一extensionへ固定しない。

### Rule 4.3: Scalability Strategy
-   **Bounded Query**: public／untrusted／collection queryはfield、row、time、scan、costをboundedにする。`select('*')`は明示的な小規模contractなら許容でき、pagination方式はconsistencyとconsumer UXから選ぶ。
-   **Filter Placement**: authoritative filterは可能な限りdata sourceへpush downする。application-side filterがpresentation-onlyか、page completeness／countを壊さないことをcontract testする。
-   **Scale Controls**: partition、replica、archive、cache、materializationをrow数だけで決めず、table／index size、growth、vacuum、lock、query plan、RPO／RTO、lag、costから選ぶ。
-   **Connection Pooling（接続プール最適化）**:
    -   **Law**: runtime concurrency、connection lifetime、prepared statement、transaction／session semantics、database capacityからdirect、transaction pool、session poolを選ぶ。
    -   **Action**:
        1.  **Elastic Runtime**: peak instance数×per-instance poolをcapacity testし、pooler／Data API／HTTP driver等を候補にconnection stormを防ぐ。
        2.  **Mode Compatibility**: transaction modeとsession feature、prepared statement、advisory lock、temporary objectの互換性をtestする。
        3.  **Headroom**: application、migration、observability、operator、replication用のheadroomをcapacity modelで予約し、固定70%をUniversal基準にしない。

### Rule 4.4: The Optimistic Mutation Protocol（楽観的更新プロトコル）
-   **Law**: optimistic UIはreversible、低risk、conflict semanticsが明確なmutationの候補とする。固定0.5秒を採用条件にせず、user research、latency SLO、failure rate、accessibilityからskeleton、progress、pessimistic、optimisticを選ぶ。
-   **Action**:
    1.  **State Model**: pending、confirmed、failed、conflicted、offlineを明示し、duplicate submitを防ぐ。
    2.  **Recovery**: rollback、reconciliation、retry、user-visible errorをdomain riskに応じて設計し、toast等の特定UIを強制しない。
    3.  **High-Risk Action**: 金銭、削除、権限変更等はserver confirmation、step-up、undo／compensationを優先する。

---

## 5. 認証とセキュリティ (Auth & Security)
-   **Identity Boundary**: Supabase Authを採用する場合もauthentication、authorization、profile、tenant membership、session revocationの権威境界と退出手順を定義する。
-   **Notification Architecture**:
    -   **Aggregation**: 同一リソースへの重複アクション（例: 複数人のいいね）は、通知テーブルで「集約」し、通知爆撃を低減します。
    -   **Async Delivery**: メール送信等は非同期ジョブ (`pgmq`等) を経由させます。
    -   **The Smart Notification Control Protocol (Email Bomb Prevention)**:
        -   **Law**: メール通知は即時送信せず、ジョブキューを介して数分〜数十分遅延させてください。
        -   **Logic**: 送信直前に「アプリ内で既読になっているか」をチェックし、既読の場合はメール送信をスキップします。
        -   **Outcome**: 「既にアプリで確認した内容のメールが後から届く」というUX劣化を防ぎ、メール爆撃による離脱を回避します。

### Rule 5.1: The RLS-by-Default Enforcement Protocol（2025年新標準）
-   **Law**: 2025年のSupabaseアップデートにより、新規テーブルには**RLSがデフォルトで有効**となります。この挙動を前提に、テーブル作成直後にポリシーを定義する運用を徹底しなければなりません。
-   **Action**:
    1.  **Immediate Policy**: テーブル作成後、ポリシー未定義の状態で放置しないでください。RLS有効 + ポリシーなし = **全アクセス拒否**です。開発中であっても最低限 `TO authenticated` のポリシーを設定してください。
    2.  **Event Triggers**: Supabaseの **Event Triggers** 機能を活用し、新規テーブル作成時に自動的にRLSを有効化するトリガーを設定してください。人為的な設定漏れリスクを低減します。
    3.  **Dashboard Alerts**: ダッシュボードの **Security Alerts** で「RLSが無効なテーブル」の警告が表示された場合、即座に対処してください。これは §0.1（Zero Tolerance Linter Protocol）の適用対象です。
    4.  **Exposed Tables**: RLSが有効でもポリシーが `USING (true)` のテーブルは実質的に全公開です。ダッシュボードの **Exposed Tables** ラベルを定期的に確認し、意図しない公開がないか監査してください。

### Rule 5.2: The Session & Token Management Protocol
-   **Law**: Supabase Authのセッションとトークン管理は、セキュリティとUXのバランスを考慮して適切に設計しなければなりません。
-   **Action**:
    1.  **Lifecycle**: platform SDKのcurrent refresh contractを使い、sign-in、refresh、expiry、revocation、sign-out、multi-tab／device、offline、clock skewをtestする。
    2.  **TTL**: access／refresh token lifetimeはthreat、revocation latency、request volume、offline UXから決め、provider defaultとcurrent limitを再確認する。固定15分／5分をUniversalへ置かない。
    3.  **Server Validation**: authorizationに使うidentityは署名、issuer、audience、expiryと必要なrevocation／freshnessをtrusted boundaryで検証する。`getUser()`、verified claims、introspection等をcurrent SDK契約から選ぶ。
    4.  **Storage**: browser、SSR、native、serverごとにXSS、CSRF、process isolation、keychain／keystore、rotationを評価し、official helperを候補に安全なstorageとcookie属性を設計する。

---

## 6. ストレージと配信 (Storage & Delivery)
-   **Delivery Boundary**: provider CDN、Cloudflareその他のedge、direct storageを、authorization、cache key、signed URL、transformation、egress、purge、residencyから選ぶ。
-   **Bucket Separation**:
    -   **Public**: 店舗写真、アバター。CDNキャッシュ最大化。
    -   **Private**: 請求書、個人書類。**Signed URL** と厳格なRLSチェックが必須。
    -   **Content Classes**: bucket／prefix／policyの分離はpublicity、tenant、retention、malware、billingから決め、広告等の固定分類をUniversalへ置かない。
-   **User Upload Hygiene**: metadata、GPS／EXIF、malware、content type、dimensions、sizeをserver-trusted validationで検査する。client-side処理だけをsecurity boundaryにしない。
-   **The Signed Upload URL Mandate (Direct-to-Storage Pattern)**:
    -   **Law**: large／untrusted uploadではdirect-to-storageを候補に、app server proxyとのauthorization、inspection、transform、egress、timeout、streaming trade-offを比較する。一律禁止しない。
    -   **Flow**:
        1. **Server Action**: 認証と権限チェックを行い、問題がなければStorageへの**Signed Upload URL**を発行してクライアントに返す。
        2. **Client Direct Upload**: クライアントから直接Storageへアップロードする。
    -   **Outcome**: アプリケーションサーバーのCPU/メモリ負荷を軽減し、Serverlessプラットフォームの転送量課金とタイムアウトリスクを回避します。

### Rule 6.1: The S3 Compatible Protocol（S3互換プロトコル）
-   **Law**: S3互換性が既存tool、multipart、backup、portabilityに価値を持つ場合にSupabase Storage S3 protocolを評価する。標準Storage APIとS3互換APIのidentity、RLS、feature、cost差を検証する。
-   **Action**:
    1.  **S3 Client Access**: AWS SDK（`@aws-sdk/client-s3`）やその他のS3互換クライアントを使用してSupabase Storageにアクセスできます。`endpoint` にSupabase StorageのS3 URLを指定してください。
    2.  **RLS with JWT**: S3プロトコルでユーザーのJWTトークンを使用して認証した場合、Storage SchemaのRLSポリシーが**自動的に適用**されます。ユーザースコープのアクセス制御が可能です。
    3.  **Standard S3 Keys**: 標準のS3アクセスキーはRLSを**バイパス**し、全ファイルにフルアクセスを提供します。サーバーサイド専用とし、クライアントへの露出を厳禁とします。
    4.  **Use Case**: マルチパートアップロード（大容量ファイル）、既存S3ツール（aws cli、rclone等）からの移行、バックアップスクリプトなど、標準Supabase APIでは対応しにくいケースで使用してください。

### Rule 6.2: The Storage Image Transformations & CDN Protocol
-   **Law**: image workloadではresponsive variants、modern format、quality、metadata、cache、authorization、origin costを設計し、Supabase transformation／CDN、build-time、別image service等を比較する。
-   **Action**:
    1.  **On-the-Fly Resize**: `supabase.storage.from('bucket').getPublicUrl('image.png', { transform: { width: 300, height: 200 } })` でサーバーサイドリサイズを活用。各デバイスに最適なサイズを配信し、帯域を節約してください。
    2.  **Format Conversion**: WebP、AVIF、JPEG等をcontentとclient supportからnegotiateし、固定削減率を前提にしない。
    3.  **CDN Cache**: Publicバケットのファイルは自動的にグローバルCDNでキャッシュされます。`Cache-Control` ヘッダーを適切に設定し、キャッシュヒット率を最大化してください。Privateバケットはユーザーごとの権限チェックが入るため、キャッシュヒット率は低下します。
    4.  **File Size Limits**: use case、plan、memory、inspection、egressからbucket／request上限を設定し、current provider limitを実装時に確認する。
    5.  **MIME Type Validation**: `allowedMimeTypes` でアップロード許可するファイルタイプを制限してください。画像バケットに`.exe`や`.js`がアップロードされることはセキュリティインシデントです。

---

## 7. 運用とマイグレーション (Operations & Migration)

### Rule 7.1: The Migration Protocol (Ghost Table Defense)
-   **Migration-first Execution**: スキーマ変更は先に `supabase migration new <name>` またはプロジェクトで承認された同等手段で不変のmigration fileを作成し、review、local reset、preview／staging検証を経て、承認済みpipelineまたはCLIから順序付きで適用します。remoteで先に変更して後から履歴を作る運用は禁止します。
-   **Migration Timestamp Hygiene**:
    -   **Context**: 手動作成ファイルのタイムスタンプが「未来」だと、自動生成ファイルの順序が狂います。
    -   **Action**: 承認済みmigration toolまたはledger inspectionで最新versionと依存順序を確認し、衝突、重複、未来時刻、clock skewを検出してください。特定shell commandだけを正本にしません。
-   **Atomic Migration**: `DROP POLICY` と `CREATE POLICY` は同一ファイル内で完了させ、セキュリティ空白期間を作らないこと。
-   **Ghost Table Defense**: 
    -   **Law**: 存在しないテーブルへの `ALTER` や `CREATE POLICY` はマイグレーションエラー (`42P01`) を引き起こします。
    -   **Action (Schema Preconditions)**: migration作成時にsource schema、依存関係、期待する型と制約を検証し、存在しなければfail closedで停止します。`IF EXISTS`や`DO $$`による条件付き実行は、意図的に複数の既知schema versionを受け入れる互換migrationに限定し、想定外driftを隠してはなりません。
    -   **Column-Level Verification (Schema-Reality突合義務)**: マイグレーション作成前およびDTO設計時は、テーブルの存在だけでなく**カラムの存在・型・制約も`information_schema.columns`で確認**してください。存在しない`example_field`等を推測でDTOへ定義することはSchema-Reality乖離の主因であり禁止です。
-   **Schema Source Reconciliation**: migration ledgerとversion管理されたschemaを正本とし、remote catalogはdrift検知と適用前確認に使用します。不一致があれば適用を止め、承認されたreconciliation migrationで解消します。

### Rule 7.2: Connectivity & CI/CD Protocol
-   **Runner Connectivity**: CI provider名や固定network仮定に依存せず、実効DNS、IPv4／IPv6、direct／pooler endpoint、transaction mode、TLS、egress policyを検証します。migration、dump、長時間transactionなどsession semanticsを要する操作は、現行公式文書と実効設定に適合する承認済み接続経路を選びます。

### Rule 7.3: Data Seeding & Caching Determinism
-   **Seed Determinism**: seed／fixtureはbusiness key、stable generator seed、explicit reference等で再現可能にし、再実行時のinsert／update／delete semanticsとproduction投入可否を定義する。全ID／値の固定を強制しない。
-   **Cache Coherence**: schema／data変更時のcache key、tag、event invalidation、TTL、version stamp、bypassから適合する方式を選び、特定framework helperやsuffixを固定しない。
-   **Verification**: seed後はexpected entities、constraints、relationships、authorizationをquery／application contractで検証し、CLI statusだけをdata存在の証拠にしない。

### Rule 7.4: Migration Idempotency Protocol
-   **Mandate**: schema migrationはledgerとchecksumで順序付きexactly-once適用し、適用済みfileを変更しない。retry対象のseed／backfillだけを冪等化し、`IF NOT EXISTS`で想定外driftを隠さない。
-   **Implementation**: expected source／target schema、transaction境界、partial failure時のforward-fix、clean rebuildとupgrade pathを検証する。

### Rule 7.5: Cache Reload Protocol
-   **Context**: マイグレーション適用後、接続プールやORMのスキーマキャッシュが古い状態を保持する場合がある。
-   **Mandate**: schema consumerをinventoryし、generated contract、ORM metadata、PostgREST schema cache、prepared statement、connection pool、running revisionのrefresh／compatibilityを検証する。再生成、cache reload、rolling restart等は必要なconsumerだけに実施し、本番全面restartを一律要求しない。

### Rule 7.6: Controlled Remote Change Policy (History Protection)
-   **Law**: Dashboard SQL Editorその他のremote consoleを、通常のschema／data変更経路にしてはなりません。標準経路はversion管理、review、検証、承認、監査を備えたmigration／operationです。
-   **Break-glass**:
    1. production incidentで標準経路がRTOを満たせない場合だけ、対象、operator、approver、reason、query、timestamp、backup／rollback、影響を記録して最小変更を許可します。
    2. 実行後は同じincident window内でmigration ledger、schema、runbook、evidenceをreconcileし、drift checkとpost-incident reviewを完了します。
    3. ad-hoc readもPII、負荷、lock、監査要件を満たすread-only roleと安全なquery budgetで行います。

### Rule 7.7: The Expand-Contract Migration Protocol（ゼロダウンタイム・スキーマ変更）
-   **Law**: live consumerとdeploy skewがある破壊的変更は、expand-contractまたは同等のbackward-compatible migrationを用い、availability target、lock budget、data volume、rollbackに合わせて段階化する。
-   **Action**:
    1.  **Expand**: old consumerが動作したまま新schema／index／compatibility layerを追加し、lock、rewrite、replication impactをpreflightする。
    2.  **Migrate**: checkpoint付きbounded backfillとreconciliationを行う。dual writeはbest-effort実装を禁止し、transaction、trigger、outbox、CDC等でordering、idempotency、partial failureを証明できる場合だけ使う。
    3.  **Contract**: telemetry、consumer inventory、query logs、generated contract、rollback windowがexit criteriaを満たした後に旧構造を廃止する。固定1週間や単一`grep`を証拠にしない。
-   **Exception**: offline maintenanceがavailability targetを満たす小規模／isolated systemでは、backup、downtime承認、restore testを伴うdirect migrationを選べる。

### Rule 7.8: The Data-Aware Defense Protocol（データ依存防衛プロトコル）
-   **Law**: migrationは実dataのdistribution、duplicate、NULL、invalid value、volume、lock、concurrent writeをpreflightし、clean rebuildとproduction-like upgradeの双方で検証する。全DMLへ同一conflict処理を強制しない。
-   **Action**:
    1.  **Precondition Query**: count／sample／constraint candidateをread-onlyで計測し、閾値超過時は停止する。
    2.  **Intentional Conflict Semantics**: insert／updateごとにfail、ignore、merge、upsertをbusiness contractから選び、`ON CONFLICT`でerrorを隠さない。
    3.  **Constraint Rollout**: duplicate remediation、quarantine、`NOT VALID`／validate、online index等をdata loss、lock、rollbackから選び、cleanupを同一fileへ無条件に埋め込まない。

### Rule 7.9: The Migration Static Analysis Guard（マイグレーション静的解析ガード）
-   **Law**: migration riskをCIで自動検査し、block、manual review、timed executionへ分類する。local hookはfast feedbackの候補であり、enforceable remote gateを正本とする。
-   **Action**:
    1.  **Detection**: destructive DDL、table rewrite、unbounded DML、long lock、non-concurrent index、volatile default、permission widening、missing rollback／preconditionをASTまたはreview可能なheuristicで検出する。
    2.  **False Positive Safety**: `UPDATE`、`INSERT`、constraintを構文だけで一律拒否せず、expected row count、WHERE、conflict semantics、preflight、maintenance windowを評価する。
    3.  **Exception**: bypassは理由、approver、owner、expiry、execution window、post-checkを持つtime-bound exceptionとし、暗黙の`--no-verify`でremote gateを回避しない。

---

## 8. 保守と堅牢化 (Maintenance & Hardening)

### Rule 8.1: Security Hardening (The Fortress)
-   **Public Schema Guard**: schema `CREATE`／`USAGE`／object privilegesをrole matrixから最小化し、provider-managed defaultとmigration roleへの影響をtestする。`REVOKE CREATE ON SCHEMA public FROM PUBLIC`は候補である。
-   **View Security**: viewのinvoker／definer semantics、underlying RLS、column exposure、ownerを用途ごとに明示する。
-   **Search Path Defense (The Qualified Schema Mandate)**:
    -   **Law**: `SECURITY DEFINER`はsafe `search_path`と完全修飾、最小grant、owner、negative testを持つ。空の`search_path`は候補であり、built-in／extension解決を含めてtestする。

### Rule 8.2: The Audit Log Mandate / WORM
-   privileged data／schema変更はactor、reason、before／after reference、result、traceをtamper-evident auditへ記録する。DB table、external immutable sink、ledger等を脅威とretentionから選び、固定table名やRLSだけをWORMとみなさない。

### Rule 8.3: The Comprehensive RLS Audit
-   **Cascading Verification**: 変更対象のactual actor、anonymous、authenticated、cross-tenant、privileged pathをcapability matrixからtestする。
-   **Risk-Based Audit**: change時とdata sensitivity／team／incidentに応じたcadenceでRLSを監査する。月次は候補である:
    - [ ] 全RLS有効テーブルでSELECT/INSERT/UPDATE/DELETEの各アクションにポリシーが存在するか
    - [ ] 必要なprivileged accessが最小scopeで動作し、通常userへ拡大していないか
    - [ ] 一般ユーザーは自分のデータのみ閲覧・操作可能か
    - [ ] row-invariant helperのplan warningをtriageし、optimization前後の認可結果が同じか

### Rule 8.4: RLS Post-Change Verification Protocol
-   **Verification Scope**: RLSポリシー変更後は以下を必ず確認:
    1.  **Security Advisor**: 各所見をrisk-basedに解消または期限付き例外化し、ゼロ件だけを安全性の証明にしない。
    2.  **Functional Test**: capability matrixのactor、operation、tenant、row／column scopeを検証。
    3.  **Performance**: safe environmentまたはproduction-safe方法でplanを確認し、sequential scan自体ではなくdata volumeとlatency／costを評価する。
-   **Risk-Based Coverage**: 変更したresourceに加え、依存view／function／job、public／authenticated／operator flow、cross-tenant denial、cached responseをimpact graphから選んで検証する。固定table名やrouteをUniversalへ持ち込まない。
-   **Emergency Recovery**: tested rollback、traffic isolation、feature flag、または対象resource／actor／timeを限定したbreak-glassで復旧する。可用性回復のために全rowを`USING (true)`で公開してはならない。
-   **Detection Symptoms (障害兆候)**:
    -   管理画面で「データがありません」だがDBには存在する。
    -   APIが403/404を返すがログには正常アクセスと記録される。
    -   本番のみデータが表示されない（開発環境との差異）。

---

## 9. ドメインデータモデリング (Domain Data Modeling)

### Rule 9.1: Universal Settings & Tenant-Aware Naming
-   **Representation**: 設定はquery、constraint、partial update、schema evolution、tenant override、auditからnormalized column、typed JSON、related table、configuration serviceを選ぶ。typed JSONBを一律禁止しない。
-   **Tenant-Aware Boundary**:
    -   **Law**: multi-tenant要件がある場合、tenant identity、scope、inheritance、override、uniqueness、RLS、billing、deletionをcontract化する。将来の可能性だけで全schemaをtenant化しない。
    -   **Naming**: `site_`、`account_`、`system_`等は例であり、resource type、scope、ownerを識別できるproject conventionをBlueprintで決める。

### Rule 9.2: Static Page Ban (CMS Sovereignty)
-   legal／policy contentはowner、review、version、effective date、locale、approval、retention、rollback、availabilityを満たす管理方式を選ぶ。version管理されたstatic content、CMS、document systemはいずれも候補であり、runtime CMS依存を一律強制しない。

### Rule 9.3: Structural Integrity Protocols
-   **Classification**: tags、enum、relation、taxonomyをcardinality、governance、localization、queryから選ぶ。
-   **Temporal Rules**: 営業時間等を扱うdomainだけがtimezone、holiday、exception、recurrence、source authorityをstructured contract化する。
-   **Scoring**: reputation／rankingを持つ場合はsample bias、gaming、uncertainty、explainabilityを評価し、単純平均、Bayesian、Wilson等をdataから選ぶ。
-   **Geospatial**: location機能が必要なentityだけにcoordinate／geometry、precision、source、consent、retentionを持たせる。

### Rule 9.5: The Geolocation Data Strategy（位置情報データ戦略）
-   **Law**: geocoding sourceはaccuracy、license、privacy、freshness、coverage、latency、cost、rate、exitから選ぶ。手入力、trusted source、provider API、batch datasetを比較し、無料を品質・利用規約より常に優先しない。
-   **Action**:
    1.  **Source Provenance**: coordinate、precision、取得元、取得時刻、license、confidence、manual overrideを記録し、URL scrapingがprovider termsとformat stabilityを満たすか確認する。
    2.  **Caching**: address normalization、retention、provider terms、freshness、correctionを満たす場合だけ結果をcache／persistする。
    3.  **Distance & Display**: local scaleではgeography／PostGIS、Haversine、provider search等からaccuracyを選び、表示単位とroundingはlocale／UXで決める。
    4.  **Spatial Index**: geometry typeとquery operatorに適合するGiST／SP-GiST等をplanで選ぶ。緯度経度へのGINを一律推奨しない。

### Rule 9.4: The Time-Gated Content Schema Standard（時限公開コンテンツスキーマ標準）
-   **Law**: scheduled publicationを持つdomainはstate machine、effective interval、timezone、embargo、unpublish、preview、clock、authorizationをcontract化する。固定column名や`NULL`意味をUniversalへ置かない。
-   **Action**:
    1.  **Illustrative Schema**: `status`と`published_at`は候補であり、`NULL`を即時公開、未予約、未設定のどれとするか明示する。
    2.  **Authorization Predicate**: public queryはstateとeffective timeを同時に評価し、preview／operator pathを分離する。次は例である。
        ```sql
        WHERE status = 'public'
          AND (published_at IS NULL OR published_at <= NOW())
        ```
    3.  **Indexing & Test**: actual predicate、sort、tenant、partial conditionからindexを設計し、境界時刻、timezone、draft、scheduled、expiredをtestする。

---

## 10. 全球相互運用性 (Universal Portability)
-   **Ecosystem Portability**: 対象システムのデータは、将来の移行、分析、規制対応、外部連携で再利用されるデジタル資産です。適用可能な業界標準、明示的なorigin・retention metadata、versioned contract、export手順を採用し、特定providerだけで解釈できる形式への不要な固定を避けてください。

---

## 11. バックエンド・ガバナンス (Backend Governance)

### Rule 11.1: The Data Residency Protocol (Rule 26.1)
-   **Law**: 特定の個人情報（PII）や法的文書は、準拠法（GDPR/APPI等）に基づき、特定のリージョン（例: 日本国内）に物理的に存在することを保証しなければならない場合があります。
-   **Action**: ストレージバケットやDBインスタンスのリージョン設計時に、将来の「データローカライゼーション要件」を考慮した構成（Multi-region Read/Local Write）を検討し、文書化してください。

### Rule 11.2: The Audit Bypass Anti-Pattern (Server Action Mandate)
-   **Law**: 書き込み経路は、riskに応じたauthentication、authorization、validation、abuse control、auditを必ず通過させます。Server Action、API、DB policy／triggerは実装候補であり、特定frameworkを一律に強制しません。
-   **Action**: 
    1. **Trusted Boundary**: 特権操作、PII、金銭、権限変更、複数entityの整合性が関わる書き込みは、server-side command boundaryまたはtransactional DB functionへ集約し、actorとdecisionを監査します。
    2. **Direct Client Writes**: RLSとschema validationで安全に表現できる低リスク操作はdirect client writeを許容できます。negative test、rate limit、idempotency、必要な監査を証明します。

### Rule 11.3: The RLS Best Practices Protocol (ポリシー衛生)
-   **Law 1: No Redundant Bypass Policy**: `service_role` credentialで接続するrequestはRLSをbypassするため、`TO service_role` policyを認可controlと誤認しない。管理者／system accessはuser-scoped RLS、限定RPC、専用role、service boundary等から最小権限の方式を選ぶ。
-   **Law 2: Explicit Policy Semantics**: 複数の`PERMISSIVE` policyは`OR`、`RESTRICTIVE` policyは追加制約として評価されます。policy数を機械的に1つへ統合せず、role、command、意図、組合せ結果をtestし、重複または過剰許可だけを除去してください。
-   **Law 3: Explicit Public Write**: `WITH CHECK (true)`は対象roleに全row insertを許す。意図したpublic ingestionでもrate、validation、abuse、quota、PII、auditを別controlで証明できない限り使用しない。所有権や管理者roleだけを唯一の正解に固定しない。

### Rule 11.4: The Poison Row Prevention Protocol (型崩壊防止)
-   **Context**: generated database contractを手動拡張すると、read、create、update、nullability、runtime validationの意味が崩れることがある。
-   **Law**: generator outputを正本として再生成可能に保ち、domain typeはadapterで分離する。`never`、intersection、inheritance等の構文自体を一律禁止せず、正当なread／insert／updateのtype testとruntime contract testで安全性を証明する。
-   **Action**:
    1.  **Generated Sovereignty**: generated fileを手動編集せず、schema revisionとgenerator versionを追跡する。
    2.  **Operation Parity**: row、insert、update、function resultを別contractとしてtestし、意図せず書込み型をuninhabitableにしない。
    3.  **Language Neutrality**: TypeScript以外でもcompiler／schema testとrepresentative SDK operationで同等の保証を持つ。

### Rule 11.5: The Idempotent Migration Protocol (冪等マイグレーション)
-   **Context**: migrationはclean rebuildと既存dataを持つupgrade pathの双方で検証します。
-   **Law**: schema migrationは順序付きで一度だけ適用し、適用履歴を検証し、共有環境へ適用後は不変とします。全DDLを再実行可能にすることは要求しません。
-   **Action**:
    -   **Fail Loudly**: `IF NOT EXISTS`や`DROP IF EXISTS`で想定外driftを隠さず、明示的preconditionとpostconditionで期待schemaを検証します。
    -   **Retry-Safe Data Work**: retryされ得るbackfill、seed、online batchだけはbusiness key、checkpoint、`ON CONFLICT`等で冪等にします。
    -   **Recovery**: transactional可否、partial failure、resume／forward-fix、backup／restore、rollback方針をmigration単位で定義します。

### Rule 11.6: The Admin/System Write Identity Protocol (管理者・system書き込みidentity)
-   **Law**: 管理者操作とsystem jobは、用途ごとに最小権限のidentityを選びます。人間の管理者は原則として検証済みuser identityとRLS／RBACを通し、`service_role`等のRLS bypassを全管理操作のdefaultにしてはなりません。
-   **Reason**: 広域bypass credentialは一つの実装不備を全dataへの権限拡大に変え、actor attributionも弱めます。session伝播不良はidentity境界を修正すべきsignalであり、全面bypassの理由ではありません。
-   **Action**:
    1.  **Human Admin**: MFA、短命session、role／tenant scope、RLS、step-up authorizationを維持し、許可された操作だけを実行します。
    2.  **System Job**: workload identity、専用DB role、限定RPC等、job単位の最小権限を優先します。bypass credentialが不可避ならserver-side secret、network restriction、rotation、監査、狭いcode pathを必須とします。
    3.  **Authorization Test**: positive／negative／cross-tenant testとactor-aware auditで、readとwriteの必要範囲を別々に証明します。

### Rule 11.7: The Silent RLS Failure Detection Protocol (RLSサイレント失敗検知)
-   **Law**: mutation結果は、使用SDK、request option、policy、対象rowの有無でresponseが変わるため、business contractに基づいて成功条件を明示的に検証します。0行または空responseだけからRLS拒否と断定しません。
-   **Action**:
    1.  **Contract Check**: exactly-one更新ならaffected rowまたはreturned identifierを検証し、zero-or-one削除等の正当な0件契約とは区別します。
    2.  **Diagnostic**: 0件時はnot found、concurrent change、filter mismatch、authorization denialを情報漏洩しないerror contractで切り分けます。
    3.  **Safe Logging**: operation、resource class、request／trace ID、結果分類を記録し、不要なPIIやraw credentialを出力しません。
-   **Diagnostic**: 「保存成功なのにリロードすると元に戻る」→ **RLSサイレント失敗を疑え**。

### Rule 11.8: The RPC Scope Limitation Protocol（RPCスコープ制限）
-   **Law**: RPC、application service、queue／workflowの配置は、atomicity、data locality、latency、portability、failure recovery、security boundary、運用能力から決めます。複雑さだけでDB実装を禁止せず、外部I/Oをdatabase transactionへ隠す設計や、検証不能な巨大RPCを避けます。
-   **Action**:
    1.  **Database Candidate**: set-based処理、constraintに近い認可、単一transactionの複数table更新はRPC候補とし、明示したinput／output、権限、timeout、lock、testを持たせます。
    2.  **Service Candidate**: 外部I/O、長時間workflow、human approval、retry orchestrationは言語非依存のapplication／workflow boundaryへ置き、outbox等でDB commitとの整合性を保ちます。
    3.  **Operability**: 選択した境界に型またはschema contract、trace、負荷試験、versioning、owner、rollbackを備えます。
-   **Rationale**: 責務配置は特定frameworkや言語ではなく、整合性とfailure boundaryの証拠で判断します。

### Rule 11.9: The Ghost Migration Ban（ゴーストマイグレーション禁止）
-   **Law**: マイグレーションファイル化されていないDB操作（手動でのカラム追加・変更・削除、Dashboard上でのスキーマ変更等）を**「ゴーストマイグレーション」と定義し、厳禁**とします。
-   **Action**:
    1.  **Migration File Mandate**: すべてのスキーマ変更は承認済みmigration toolを経由し、version管理された不変のmigration artifactとして保存します。
    2.  **No Dashboard Edits**: DB管理画面からの通常時の直接変更は禁止します。緊急break-glass時はactor、approval、query、resultを記録し、直後にmigration ledgerとversion管理artifactをreconcileします。
    3.  **Schema Consistency Protocol**: ローカル環境のスキーマがマイグレーションファイルと乖離（汚染）した場合は、DB再構築（`supabase db reset` 等）を躊躇してはなりません。常にマイグレーションファイルをSource of Truth（正）として扱い、ローカルDBを従とします。
    4.  **Verification**: マイグレーション適用後は、ローカルスキーマとリモートスキーマの差分がゼロであることを確認してください。差分がある場合はゴーストマイグレーションの存在を疑います。
-   **Rationale**: マイグレーションファイルに記録されない変更は、チーム間での再現不能、CI/CD障害、本番環境との不整合を引き起こします。「全ての変更は記録される」という原則は、スキーマの信頼性を支える基盤です。

## 12. マイグレーションと特権操作 (Migrations & Privileged Operations)

### Rule 12.1: The Admin Write Service Role Protocol（管理者書き込みのService Role使用義務）
-   **Law**: 管理画面とbackground jobはRule 11.6のidentity matrixに従い、user-scoped、job-scoped、privileged identityから最小のものを選びます。Service Role Keyは例外的なbreak-glass／system boundaryであり、通常の管理者操作へ一律適用しません。
-   **Action**:
    1.  **Human Path**: user identity、MFA、RBAC／RLS、tenant scopeを維持します。
    2.  **Machine Path**: workload identityまたは専用roleを使用し、table／operation scopeを限定します。
    3.  **Bypass Guard**: bypass secretはclientへ露出せず、利用箇所、owner、rotation、監査、incident revocationを管理します。
    4.  **Audit Trail**: actor、reason、scope、resultを改ざん耐性のある監査証跡へ残します。

### Rule 12.2: The Idempotent Migration Protocol（冪等マイグレーション義務）
-   **Law**: schema migrationは履歴tableとchecksumでexactly-once適用を検証し、共有環境へ適用後は変更しません。再試行されるdata operationだけを明示的に冪等化します。
-   **Action**:
    1.  **Pre/Postconditions**: expected source schemaとtarget schemaをassertし、想定外状態ではfail closedします。
    2.  **Atomicity**: transactional DDLが使える範囲を明示し、非transactional operationはcheckpointとresume／forward-fixを設計します。
    3.  **Data Operations**: backfillやseedはbusiness key、upsert policy、batch checkpoint、reconciliationでretry-safeにします。
    4.  **Clean and Upgrade Tests**: empty databaseへの全履歴適用と、supported previous stateからのupgradeを両方testします。

### Rule 12.3: The Permissive Policy Semantics Protocol
-   **Law**: 同一role／commandの論理的に重複する`PERMISSIVE` policyは除去するが、policy数そのものをsecurity targetにしない。`service_role` credentialのRLS bypassと、通常roleのpolicyを別境界として扱う。
-   **Action**:
    1.  **Combined Access**: table、role、command単位で全policyとgrantを一覧し、`PERMISSIVE` ORと`RESTRICTIVE` ANDのcombined resultをtestする。
    2.  **Consolidation Decision**: 重複、過剰許可、measured overheadがある場合に統合する。異なるowner、role、lifecycleを明確化する分離は許容する。
    3.  **Bypass Inventory**: bypass credential／roleの利用pathはpolicy外の最小権限、secret、network、audit、rotationで統制する。

### Rule 12.3.1: The RLS Auth Function InitPlan Optimization（RLS認証関数InitPlan最適化）
-   **Law**: row-invariantなauth／session helperは、公式推奨、volatility、query planが示す場合にscalar subqueryでInitPlan化する。correlated expression、row-dependent helper、set-returning functionへ機械適用しない。
-   **Action**:
    1.  **Candidate**: `user_id = (select auth.uid())`はrow-invariant helperの候補patternである。
    2.  **Semantics**: `EXISTS`、join、tenant lookupではcorrelation、cardinality、NULL、index利用を保つ。
    3.  **Evidence**: representative role／dataでauthorization testと`EXPLAIN (ANALYZE, BUFFERS)`または安全な同等手段を比較する。
-   **Illustration**:
    ```sql
    -- Before measurement
    USING (user_id = auth.uid())
    -- Candidate after semantic and plan verification
    USING (user_id = (select auth.uid()))
    ```

### Rule 12.4: The Type Extension Safety Protocol（型拡張安全プロトコル）
-   **Law**: generated schema／SDK contractは手動改変せず再生成可能にし、domain extensionは別adapterでversion管理する。言語ごとのtype systemに合う手法を選び、runtime schemaとoperation testでdriftを検出する。
-   **Action**:
    1.  **Uninhabitable Type Check**: `never`等で正当なoperationを不可能にしていないかをcompile testする。
    2.  **Composition Choice**: alias、interface、intersection、mapped type、class、code generationはtoolchainとreadabilityから選ぶ。
    3.  **Contract Coverage**: read、insert、update、RPC、nullable、JSON、decimal、timestampのrepresentative caseをtestする。

### Rule 12.5: The Migration System Schema Exclusion Protocol（マイグレーション・システムスキーマ除外プロトコル）
-   **Law**: データベースマイグレーションにおいて、関数のセキュリティ設定（`search_path`、`SECURITY DEFINER/INVOKER`等）を一括変更するスクリプトを作成する際、**マネージドサービスが管理するシステムスキーマの関数は除外リストに含める**ことを義務付けます。
-   **Action**:
    1.  **Exclusion List**: `auth`, `storage`, `realtime`, `supabase_functions`, `graphql`, `graphql_public`, `pgsodium`, `vault`, `extensions` などのシステムスキーマの関数は、一括変更の対象から明示的に除外してください。
    2.  **Schema Filter**: マイグレーションスクリプトの `WHERE` 句で `n.nspname NOT IN ('auth', 'storage', ...)` を使用し、システムスキーマの関数への干渉を物理的に防止してください。
    3.  **Dry Run**: 一括変更マイグレーションを適用する前に、対象となる関数の一覧をプレビュー（`SELECT` のみ実行）し、システム関数が含まれていないことを確認してください。
-   **Rationale**: マネージドサービスのシステム関数（認証、ストレージ管理等）の `search_path` やセキュリティ設定を変更すると、サービスの基盤機能が破壊される可能性があります。これは即座にサービス全停止につながる致命的な障害です。

### Rule 12.6: The RLS InitPlan Optimization Protocol（RLS InitPlan最適化義務）
-   **Law**: Rule 12.3.1を正本とする。RLS helperのInitPlan化はrow invariance、planner behavior、公式推奨、実測が揃う場合に行い、全session functionへ一律適用しない。
-   **Action**:
    1.  linter warningは所見としてtriageし、query semanticsとplanを確認する。
    2.  optimization前後でpositive／negative／cross-tenant resultが同一であることをtestする。
    3.  固定row数や「数十倍」をUniversal保証にせず、実datasetのlatency、CPU、bufferで判断する。

### Rule 12.7: The Client Identity Audit Protocol（クライアントIDコンテキスト監査義務）
-   **Law**: RLSポリシーの最適化（統合・削除）を行う前に、対象データにアクセスする**全ての経路**（Server Action、API Route、SSR、管理画面等）が**どのIDENTITY**（`service_role` / User JWT / Anonymous）を使用しているかを**網羅的に監査**しなければなりません。
-   **Action**:
    1.  **Access Path Inventory**: 対象テーブルにアクセスする全てのコードパス（Service層、Gateway層、Server Action等）をリストアップし、それぞれが使用するクライアント初期化関数（`createClient`, `createAdminClient` 等）を特定してください。
    2.  **No Blind Optimization**: 「`service_role` で十分だから」という理由でユーザーJWT向けのポリシーを削除しないでください。Server Action等がユーザーJWTを使用している場合、そのポリシーの削除は正規アクセスのサイレントな遮断を引き起こします。
    3.  **Identity Matrix**: 複雑なテーブルに対しては、「テーブル × 操作 × 使用IDENTITY」のマトリクスを作成し、全てのアクセスパターンが少なくとも1つのRLSポリシーでカバーされていることを確認してください。
    4.  **Post-Change Verification**: ポリシーを変更・削除した後は、影響を受ける全てのUIフロー（管理画面の編集・保存、ユーザー向けの閲覧等）を実際に操作して動作を確認してください。
-   **Rationale**: RLSポリシーの「最適化」による不用意な削除は、セキュリティホールではなく「正規アクセスの不可視化」を招きます。特に管理画面がServer Action（ユーザーJWTコンテキスト）を使用している場合、service_roleで十分だと思ってJWT向けポリシーを削除すると、管理者のCRUD操作がサイレントに拒否されます。

### Rule 2.8: The Idempotent Migration Protocol（冪等マイグレーション義務）
-   **Law**: migration全体の安全性は「全DDLの再実行」ではなく、順序付きexactly-once適用、適用済みfileの不変性、明示的precondition、retry-safeなdata stepで保証します。
-   **Action**:
    1.  **DDL Drift Detection**: `IF NOT EXISTS`等は期待済み状態だけに限定し、object definitionの不一致を別途assertします。
    2.  **DML Retry Safety**: seed／backfillは意図したconflict semantics、checkpoint、reconciliationを持たせます。
    3.  **Object Replacement Safety**: function、trigger、policyのreplace／drop-createはdependency、permission、availability、transaction境界を検証します。
    4.  **History Integrity**: migration ledger、checksum、clean rebuild、upgrade testをCI evidenceにします。

### Rule 2.9: The Read-Write Privilege Symmetry（読み書き権限の対称性）
-   **Law**: 各read／write pathはactor、resource、operationに必要な最小権限を個別に持ちつつ、product contract上必要なfieldとrowの整合を保証します。writeがbypass identityだからという理由だけでreadも同じ広域権限へ引き上げてはなりません。
-   **Action**:
    1.  **Capability Matrix**: screen／job／APIごとにread fields、write fields、row scope、actor identityをmatrix化し、欠落と過剰権限を同時に検査します。
    2.  **DTO Synchronization**: edit DTOとmutation schemaの意図した差分をversioned contractとしてtestします。readに出せないsecret／internal fieldをwrite権限へ合わせて露出しません。
    3.  **Scoped Admin Gateway**: 管理操作はresource／operationを限定したgatewayまたはRPCで表現し、table全体のRLS bypassや全面開放を避けます。
    4.  **Post-Update Verification**: 重要mutationはauthorized viewからversion／identifier／expected fieldを再取得し、PIIを含まないtraceで整合を確認します。
-   **Rationale**: 必要なread-backが不足すると不透明な保存失敗に見えますが、解決策は権限の全面対称化ではありません。最小権限を保ったcapability contractと明示的verificationで整合を証明します。

### Rule 2.10: The RLS Policy Composition Protocol
-   **Law**: policy compositionはeffective authorization、ownership、可読性、監査性、性能を同時に最適化する。単一policyをUniversalの目的にしない。
-   **Action**:
    1.  **Consolidation by Evidence**: 同じrole／command／intentの重複条件は統合候補とし、異なるroleやownerを`USING (true)`へ広げない。
    2.  **Service Role Redundancy Elimination**: `service_role` はRLSを完全にバイパスするため、`service_role` 向けの明示的なポリシーは冗長です。`service_role` のみを対象としたポリシーが存在する場合は削除してください。
    3.  **RESTRICTIVE Policy Awareness**: `RESTRICTIVE` ポリシーは全ての `PERMISSIVE` ポリシーの**AND条件**として評価されるため、統合対象は `PERMISSIVE` ポリシーのみです。`RESTRICTIVE` ポリシーの統合は副作用を引き起こす可能性があります。
    4.  **New Table Checklist**: actor／role／commandごとの意図、combined result、test ownerを記録し、複数policyには分離理由を残す。

### Rule 2.11: The Orphan File Defense Protocol（孤立ファイル防衛）
-   **Law**: DB recordとobjectのlifecycle contractを定義し、unowned object、意図しない残存、早すぎる削除を防ぐ。
-   **Action**:
    1.  **Deletion Workflow**: synchronous、queue、outbox、storage lifecycle ruleから整合性、latency、retry、restore、legal holdに合う方式を選ぶ。
    2.  **Reconciliation**: risk-based cadenceでreferenceとobject inventoryを比較し、quarantine、grace period、dry run後に削除する。週次を固定しない。
    3.  **Restore Semantics**: soft delete／archive採用時はobject retentionとrecord restore windowを一致させる。

### Rule 2.12: The Safety Valve Protocol（安全弁カラム義務）
-   **Law**: free-text fieldは明示したbusiness／operational needがあるentityだけに追加する。「念のため」の自由記述列を全tableへ強制せず、PII、access、retention、search、moderation、exportを設計する。
-   **Action**:
    1.  **Typed Promotion**: recurring decision、filter、authorizationに使う情報はversioned typed fieldへ昇格する。
    2.  **Bounds**: length、format、rendering、malicious content、sensitive dataをvalidationする。
    3.  **Nullability**: required／optionalはdomain invariantから決める。

### Rule 2.13: The Time-Series Partitioning & Retention Protocol（時系列パーティション＆保持期間戦略）
-   **Law**: time-series tableはgrowth、query predicate、vacuum、index、backup、retention、delete costを観測し、partitioningの利益が運用複雑性を上回る場合に採用する。
-   **Action**:
    1.  **Partition Key & Interval**: actual queryとdata distributionからrange／hash／list、key、intervalを選び、`created_at`、月次、`pg_partman`、10Mを固定しない。
    2.  **Lifecycle**: create-ahead、default partition、retention、detach／archive、index、FK、replication、restoreをtestする。
    3.  **Decision Evidence**: non-partitioned baselineとprototypeをplan、latency、maintenance時間、costで比較する。

### Rule 2.14: The Cold Data Offloading Protocol（アーカイブ戦略）
-   **Law**: data temperature、retention、retrieval SLO、legal hold、deletion、format longevity、costからactive、archive、object、warehouseを選ぶ。1年を固定境界にしない。
-   **Action**:
    1.  **Contract**: archive owner、schema／format version、encryption、access、index/catalog、retrieval、restore test、deletion propagationを定義する。
    2.  **Cutover**: consumer contract、backfill checkpoint、checksum、late-arriving data、rollbackを検証する。
    3.  **Compliance**: retention期間はjurisdiction、record class、legal advice、policyから導出し、例示年数をUniversal法令判断にしない。

### Rule 2.15: The RLS Inheritance Protocol（権限継承・Chain of Trust）
-   **Law**: authorization sourceはdomain ownership、membership、delegation、resource relationから明示する。parent継承、direct owner、capability table、claim、policy serviceを比較し、全childを最上位parentへ一律遡らせない。
-   **Action**:
    1.  **Consistency**: denormalized owner／tenant keyを使う場合はFK、trigger、generated value、write boundaryでdriftを防ぐ。
    2.  **Performance**: `EXISTS`、join、helper、claimをpositive／negative／cross-tenant testとplanで比較する。
    3.  **Privilege**: cross-table checkはまずinvoker semanticsで表現し、`SECURITY DEFINER`は本当にelevationが必要な最小境界だけにする。

### Rule 2.16: The Brittle Table Reference Prohibition（動的テーブル参照禁止）
-   **Law**: dynamic SQLはstatic SQLで表現できないmetadata-driven operationだけに限定し、identifier quoting、allowlist、parameter binding、least privilege、test、auditを必須とする。
-   **Action**:
    1.  **Static Default**: known objectへのreferenceは静的SQLを既定とし、dependencyをmigration時に検出する。
    2.  **Safe Dynamic Identifier**: value parameterだけでidentifierを保護できないため、server-controlled allowlistと`format('%I', identifier)`等の正しいidentifier quotingを使用する。
    3.  **Impact Inventory**: dynamic dependencyはcatalog／registryへ記録し、rename／drop前にtestする。

### Rule 2.17.1: The Data Quality Management Framework（データ品質管理フレームワーク）
-   **Law**: material data productはconsumer contractとriskに応じてaccuracy、completeness、consistency、freshness、uniqueness、conformity等の適用次元をowner付きで管理する。全dataを収益資産とみなさず、privacy minimizationとdeletionを優先する。
-   **DQ Framework**:

    | 品質次元 | 定義 | 計測方法 | 目標 |
    |:---------|:-----|:---------|:-----|
    | **正確性 (Accuracy)** | データが現実を正しく反映しているか | source reconciliation／sampling | Blueprint target |
    | **完全性 (Completeness)** | contract上必要なfieldが埋まっているか | NULL／missing率 | Blueprint target |
    | **一貫性 (Consistency)** | entity、source間に矛盾がないか | constraint／cross-source検証 | Blueprint target |
    | **鮮度 (Freshness)** | consumer SLO内で更新されるか | event／load age | Blueprint target |
    | **一意性 (Uniqueness)** | business keyの重複がないか | duplicate query | Blueprint target |
    | **適合性 (Conformity)** | schema／format contractに合うか | validation | Blueprint target |

-   **Action**:
    1.  **Automated DQ Checks**: freshnessとimpactに応じたcadenceで自動計測し、結果をconsumerとownerへ可視化する。
    2.  **Asset Registry**: material datasetにowner、consumer、classification、quality SLO、lineage、retentionを記録する。
    3.  **Quarantine & Repair**: invalid dataはblind deletionせず、reject、quarantine、repair、backfill、consumer notificationをcontract化する。
    4.  **Response**: threshold違反はseverity、owner、error budget、期限、waiverを持つ。固定30日を全domainへ適用しない。

---

## 13. Edge Functions設計戦略 (Edge Functions Design Strategy)

### Rule 13.1: The Edge Functions Architecture Protocol
-   **Law**: Edge Functionsはcurrent runtimeの実行時間、memory、CPU、region、network、concurrency、background work、dependency、observability、costを確認し、HTTP／webhook／orchestration等のfitするworkloadだけを配置する。
-   **Action**:
    1.  **Cohesion**: ownership、deploy、rollback、dependency、blast radiusが一致するresponsibilityをまとめ、固定1 task／functionを強制しない。
    2.  **State**: local mutable stateをdurable authorityにせず、DB、queue、object store等へ置く。instance cacheはcorrectnessに依存しないoptimizationとして扱う。
    3.  **Runtime Limit**: plan／region／runtimeのcurrent limitとcancellationをdeployment時に検証し、超えるworkloadはjob、queue、worker、database operation等へ移す。
    4.  **Startup & Supply Chain**: dependency graph、artifact size、remote import、lock／integrity、cold startを測定し、immutable resolved dependencyをbuild evidenceにする。
    5.  **Nested Call Budget**: direct recursion、function chaining、circular call、fan-outをrequest chainとしてinventory化する。hosted runtimeがchain全体へ共有limitを適用し得るため、実効quotaと429挙動をdeploy時に再確認し、unbounded recursionを避ける。長時間・高fan-out処理はqueue、durable workflow、bounded orchestrator等へ分離し、timeout、retry／backoff、idempotency、cost ceiling、cycle detectionを設計する。

### Rule 13.2: The Edge Functions Security Mandate
-   **Law**: caller identity、authorization、input、abuse、network／egress、secret、data access、auditをendpoint threat modelに応じて多層化する。
-   **Action**:
    1.  **Caller Verification**: user JWT、webhook signature、mTLS／workload identity、public anonymous等からendpoint contractに合う方式を選ぶ。JWTを使う場合はtrusted boundaryでclaimとauthorizationを検証する。
    2.  **CORS Configuration**: browser accessではorigin、method、header、credential、preflight、cacheを設計する。credentialなしの意図的public resourceでは`*`が有効な場合もあり、environment名だけで禁止しない。
        ```typescript
        // ✅ CORS設定テンプレート
        const corsHeaders = {
          'Access-Control-Allow-Origin': Deno.env.get('ALLOWED_ORIGIN') ?? '',
          'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
        };
        // OPTIONSプリフライトへの応答
        if (req.method === 'OPTIONS') {
          return new Response('ok', { headers: corsHeaders });
        }
        ```
    3.  **Secret Management**: secretは承認済みstoreからruntime bindingで取得し、source、log、responseへ露出しない。`supabase secrets set`はmanaged projectの候補commandである。
    4.  **JWT Verification Setting**: provider JWT verificationを無効化するendpointは、webhook等の別authentication、public contract、rate／abuse control、negative test、ownerを証明する。flag名やproductionという環境名だけで安全性を判断しない。

### Rule 13.3: The Edge Functions Error Handling & Observability
-   **Law**: Edge Functionsのエラーは構造化された形式で記録し、呼び出し元に適切なHTTPステータスコードを返さなければなりません。
-   **Action**:
    1.  **Structured Error Response**: エラー発生時は、HTTPステータスコード + JSON形式のエラーボディを返してください。
        ```typescript
        return new Response(
          JSON.stringify({ error: 'Invalid input', details: '...' }),
          { status: 400, headers: { 'Content-Type': 'application/json', ...corsHeaders } }
        );
        ```
    2.  **Logging**: provider log routingを確認し、machine-queryable event、trace／request ID、severity、resultを記録する。PII、token、raw payloadを出力せず、JSON二重encodeを避ける。
    3.  **Retry Safety**: caller／providerがretry可能なmutationとexternal side effectだけをidempotent／duplicate-safeにし、request IDをidempotency keyと混同しない。

### Rule 13.4: The Edge Functions Local Development Protocol
-   **Law**: local／isolated project／previewで再現可能なtestを行い、production直接debugを通常経路にしない。local emulationの差はdeployed integration testで補う。
-   **Action**:
    1.  **Local Serve**: `supabase functions serve`はmanaged CLIの候補であり、current runtime、env、network、auth差を記録する。
    2.  **Shared Code**: shared package、workspace、provider推奨directoryをownershipとversioningから選び、固定pathに依存しない。
    3.  **Dependencies**: runtimeが対応するmanifest／lock／integrity mechanismでdirect・transitive versionを再現可能にする。

---

## 14. Realtime設計戦略 (Realtime Design Strategy)

### Rule 14.1: The Realtime Channel Architecture
-   **Law**: Supabase Realtimeの3つの機能（**Postgres Changes**, **Broadcast**, **Presence**）を正しく使い分け、チャネル設計はスケーラビリティとセキュリティを考慮しなければなりません。
-   **Action**:
    1.  **Postgres Changes**: テーブルの INSERT/UPDATE/DELETE をリアルタイムに購読する場合に使用。RLSポリシーが自動的に適用されるため、ユーザーは自身に閲覧権限のある行のみ受信。
        -   **Publication設定**: 監視対象テーブルを `supabase_realtime` パブリケーションに追加してください（`ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;`）。
        -   **フィルタリング**: `.on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'messages', filter: 'room_id=eq.xxx' })` のようにフィルタを指定し、不要なイベント受信を排除してください。
    2.  **Broadcast**: サーバーを介さないクライアント間の低レイテンシ通信（カーソル位置共有、タイピングインジケーター等）に使用。DBには保存されず、接続中のクライアントのみ受信。
    3.  **Presence**: オンライン状態の追跡（「誰がこの部屋にいるか」）に使用。各クライアントのステート（表示名、アバター等）を同期。
-   **Anti-pattern**: チャットメッセージの配信にBroadcastを使用すること。メッセージはDBに永続化し、Postgres Changesで配信するのが正しい設計。Broadcastはエフェメラル（一時的）なデータのみ。

### Rule 14.2: The Realtime Security & Performance Protocol
-   **Law**: Realtimeチャネルは、認証・認可、tenant境界、帯域、fan-out、接続数、順序、再接続、欠損許容、costをcontract化します。
-   **Action**:
    1.  **RLS Enforcement**: Postgres Changesは自動的にRLSポリシーを通過するため、RLSが正しく設定されていればセキュリティは担保されます。ただし、`USING (true)` のテーブルは全データが全ユーザーにブロードキャストされる点に注意してください。
    2.  **Channel Granularity**: チャネル名は細粒度（例: `room:${roomId}`）に設計してください。1つの「全体チャネル」に全イベントを流すと、全クライアントが全イベントを受信し帯域を浪費します。
    3.  **Connection Budget**: 契約planと実効quotaを公式資料・設定から確認し、peak user、tab／device、reconnect storm、headroomをcapacity testします。consumer lifecycle終了時はSDKに適したunsubscribe／cleanupを行います。
    4.  **Event Rate Control**: 高頻度eventはUX latency、loss tolerance、message size、provider quotaからthrottle、debounce、sampling、aggregationを選び、固定間隔をUniversalへ置きません。
    5.  **Lifecycle Cleanup**: React unmountに限らず、component、view、process、socket、background transitionの所有権境界でsubscriptionを解除し、再接続時の重複listenerをtestします。
        ```typescript
        useEffect(() => {
          const channel = supabase.channel('room:123')
            .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'messages' }, handler)
            .subscribe();
          return () => { supabase.removeChannel(channel); };
        }, []);
        ```

### Rule 14.3: The Realtime Data Flow Decision Matrix
-   **Law**: リアルタイムデータの配信手段は、データの永続性・配信対象・レイテンシ要件に基づいて選択しなければなりません。

    | ユースケース | 推奨手段 | 理由 |
    |:------------|:---------|:-----|
    | チャットメッセージ | Postgres Changes | 永続化必須。RLSで自動フィルタ |
    | タイピングインジケーター | Broadcast | エフェメラル。DB保存不要 |
    | オンラインステータス | Presence | 接続状態同期に特化 |
    | 通知バッジ更新 | Postgres Changes | DB上の通知テーブルを購読 |
    | 協調編集（カーソル） | Broadcast | 低レイテンシ・エフェメラル |
    | ダッシュボード数値更新 | Postgres Changes | 集計テーブルの変更を購読 |
    | 分析基盤への継続複製 | managed CDC／Pipelines (§15.4) | initial copy、再送、復旧を管理し、end-user向けRealtimeと責務を分離 |

---

## 15. Cron & Queues設計戦略 (Cron & Queues Design Strategy)

### Rule 15.1: The pg_cron Scheduling Protocol
-   **Law**: 定期taskにはdatabase scheduler、platform scheduler、workflow engine等から、transaction proximity、runtime、retry、secret、observability、blast radius、portabilityに適した方式を選びます。`pg_cron`は候補であり一律必須ではありません。
-   **Action**:
    1.  **Cron Expression**: 標準のcron式（`分 時 日 月 曜日`）で定義。UTCベースであることに注意し、JST（+9h）との変換を明確にコメントしてください。
        ```sql
        -- 毎日AM3:00 JST = 18:00 UTC にデータパージ実行
        SELECT cron.schedule(
          'purge-expired-sessions',
          '0 18 * * *', -- UTC 18:00 = JST 03:00
          $$DELETE FROM public.sessions WHERE expires_at < NOW() - INTERVAL '30 days'$$
        );
        ```
    2.  **Idempotent Jobs**: Cronジョブ内のSQLは冪等に設計してください。ジョブの重複実行（前回が完了する前に次回が開始）を想定し、ロック機構（`pg_advisory_lock`）の活用を推奨します。
    3.  **Monitoring**: start／finish、duration、attempt、checkpoint、affected count、resultを監視し、SLOとriskに応じたalert／review cadenceを定義します。
    4.  **Resource Guard**: 大量処理は測定したlock、WAL、replication lag、latency、memory、timeoutに基づくbounded batchとbackpressureを使用し、固定batch sizeをUniversalへ置きません。

### Rule 15.2: The Message Queue Protocol (pgmq / Supabase Queues)
-   **Law**: latency、failure isolation、durability、ordering、throughput、delivery semanticsが非同期境界を必要とする処理では、Supabase Queues、別broker、workflow engine等を能力比較して選びます。短い同期処理や強いtransaction整合性を無条件にqueue化しません。
-   **Action**:
    1.  **Queue-First Architecture**: ユーザーのリクエスト処理内で外部APIの呼び出しやメール送信を行わないでください。メッセージをキューに投入し、ワーカー（Edge Function/pg_cron）が非同期で処理する設計としてください。
    2.  **Retry Strategy**: transient failureだけをjitter付きbackoffとretry budgetで再試行し、permanent errorはquarantine／DLQへ分類します。回数・上限・再投入条件はdependency SLOとbusiness deadlineから決めます。
    3.  **Lease and Redelivery**: visibility／leaseはprocessing distribution、heartbeat、shutdown、network partitionから設定し、at-least-once再配信を前提にidempotency keyとatomic side effectを設計します。
    4.  **Message Size**: キューメッセージは**最小限のデータ**（IDと操作種別のみ）を含めてください。大量データをメッセージに詰め込むのではなく、本体データはDBに保持し、メッセージにはポインタ（ID）のみ含めるパターンを推奨します。
-   **Anti-pattern**: Server Action内で `await sendEmail(...)` を直接実行し、ユーザーにメール送信完了まで待たせること。キューに投入して即座にレスポンスを返してください。

### Rule 15.3: The Database Webhook Protocol
-   **Law**: 変更通知にはdatabase webhook、outbox、CDC、queue、bounded polling等から、delivery guarantee、ordering、replay、transaction整合性、consumer数、costに合う方式を選びます。
-   **Action**:
    1.  **Event-Driven**: Webhookはテーブルのトリガーイベントに対して自動的にHTTPリクエストを発行します。外部サービス（Slack通知、Analytics、CRM連携等）へのリアルタイム連携に使用してください。
    2.  **Idempotency**: Webhookの受信側は冪等に設計してください。ネットワーク障害によるリトライで同一イベントが複数回配信される可能性があります。
    3.  **Sender Authentication**: shared-secret署名、asymmetric signature、mTLS、workload identity等の承認方式でsender、integrity、timestamp／nonceを検証し、replayを拒否します。固定header名をUniversalへ置きません。

### Rule 15.4: The Managed CDC / Pipelines Protocol
-   **Law**: managed CDC／Pipelinesは、transactional databaseからanalytics、search、warehouse等へ変更を継続複製する境界です。transactional outbox、end-user向けRealtime、backupの代替とは見なしません。
-   **Action**:
    1.  **Capability and Maturity**: currentのavailability、support tier、destination、delivery semantics、limit、priceを採用時と更新時に確認します。alpha／preview等は§60のmaturityと例外管理に従い、利用可能という理由だけでStandardへ昇格させません。
    2.  **Delivery Correctness**: initial snapshotとWAL境界、at-least-once再送、duplicate、ordering scope、delete／truncate、checkpoint、slot、lag、backpressure、recoveryをcontract化します。consumerはidempotentにし、sourceとdestinationのreconciliationを自動化します。
    3.  **Schema and Data Governance**: table、column、rowのallowlist、PII、residency、encryption、access、retentionを定義します。自動schema反映を互換性reviewの代替にせず、breaking changeはexpand-contractで進めます。serviceがdataを変換せず複製する場合は、sourceまたはdestination側のmasking／transformationと失敗時挙動を明示します。
    4.  **Operations**: owner、replication lag、failure、slot growth、source overhead、destination quota、pause／resume／rebuild、runbook、RPO／RTO、export／exitを持ちます。監視画面の存在だけを復旧可能性の証拠にしません。
    5.  **FinOps**: initial copy、active duration、change volume、egress、destination storage／query、logをcost driverとして予算化し、異常増加時のalert、停止条件、復旧手順を決めます。

---

## 16. Observability & FinOps戦略 (Observability & FinOps Strategy)

### Rule 16.1: The Database Performance Monitoring Protocol
-   **Law**: データベースのパフォーマンスは、**能動的な監視と予防的な最適化**により維持しなければなりません。「遅いと感じてから対応する」リアクティブなアプローチを禁止します。
-   **Action**:
    1.  **Workload Evidence**: `pg_stat_statements`等の実効telemetryでtotal time、tail latency、frequency、rows、I/O、lockを観測し、SLO・cost・change riskに応じたcadenceとquery budgetで上位寄与queryをreviewします。固定件数や100msをUniversal基準にしません。
        ```sql
        -- 最も遅いクエリTop 10
        SELECT query, calls, mean_exec_time, total_exec_time
        FROM pg_stat_statements
        ORDER BY mean_exec_time DESC
        LIMIT 10;
        ```
    2.  **Index Advisor**: Supabase Dashboardの **Index Advisor** を活用し、推奨インデックスの提案を定期的に確認してください。提案されたインデックスを盲目的に適用するのではなく、書き込みパフォーマンスへの影響も考慮して判断してください。
    3.  **Connection Monitoring**: active／idle／waiting connection、pool saturation、queue time、reserved headroomをcapacity modelとSLOからalert化します。
    4.  **Table Maintenance**: dead tuple、vacuum lag、wraparound、table／index bloat、write rateを観測し、provider-managed autovacuumを尊重しつつ測定根拠とrunbookに従ってtuning／maintenanceします。

### Rule 16.2: The Supabase Monitoring Checklist
-   **Law**: Dashboard、API、metrics export、log／trace drainから、database、disk、API、Auth、Functions、Realtime、Storageのgolden signals、quota headroom、growth、security anomalyを監視します。threshold、window、cadence、owner、escalationはSLO、forecast、contract plan、incident historyからBlueprintで定義します。

### Rule 16.3: The Supabase FinOps Protocol（コスト最適化）
-   **Law**: Supabaseの課金モデルを正確に理解し、コスト最適化をアーキテクチャ設計の一部として組み込まなければなりません。
-   **Action**:
    1.  **Billing Awareness**: 以下の課金軸を理解し、各軸で使用量を監視してください：

        | 課金軸 | Free Tier上限 | Pro上限 | コスト削減戦略 |
        |:-------|:-------------|:--------|:-------------|
        | **Database** | 500MB | 8GB含 | インデックス最適化、Cold Data Offloading(§2.14) |
        | **Storage** | 1GB | 100GB含 | 画像圧縮、CDNキャッシュ、孤立ファイル削除(§2.11) |
        | **Bandwidth** | 5GB | 250GB含 | CDN活用、`select()` の最小化、ページネーション |
        | **Edge Functions** | 500K呼出 | 2M含 | バッチ処理、不要な呼び出し削減 |
        | **Realtime** | 200接続 | 500接続 | チャネル設計最適化、不要接続のクリーンアップ |
        | **Auth MAU** | 50K | 100K含 | ボット対策、不正アカウント削除 |

    2.  **Query Optimization for Cost**: public／large／high-frequency pathは必要fieldとbounded resultを選びます。明示的な小規模contractでの`select('*')`を一律禁止せず、schema expansionと転送costをtestします。
    3.  **Storage Tiering**: CDN（Cloudflare等）で画像・静的アセットをキャッシュし、Supabase Storageへの直接アクセスを最小化してください。帯域課金の最大の削減策です。
    4.  **Non-Production Economics**: dev／test／previewは必要なisolation、availability、data class、quota、resume time、contract条件からplanとlifecycleを選びます。課金回避だけのsynthetic keep-aliveを実行しません。
    5.  **Compute Add-on Rightsizing**: DB Compute Add-onは実際のCPU/メモリ使用量に基づいて適切なサイズを選択してください。過剰なComputeは直接的なコスト浪費です。

### Rule 16.4: The Log Management Protocol
-   **Law**: Supabaseが生成するログ（API、Auth、Database、Edge Functions）を一元管理し、インシデント調査に即座に活用可能な状態を維持しなければなりません。
-   **Action**:
    1.  **Log Drain**: 本番環境では、Supabaseの **Log Drain** 機能を使用して外部ログ管理サービス（Datadog、Logflare、BigQuery等）にログを転送してください。Supabaseダッシュボードのネイティブログは保持期間が限定されています。
    2.  **Structured Logging**: Edge Functions内では `console.log(JSON.stringify({ event, correlationId, outcome, duration }))` 等の個人識別子を含まない構造化ログを出力し、検索・フィルタリングを容易にしてください。本人識別が必要なsecurity auditは一般application logから分離し、目的限定、最小権限、改ざん耐性、保持・削除を備えた保護audit sinkへ記録します。
    3.  **Sensitive Data Control**: credential、token、passwordは記録せず、PIIは目的・法的根拠・最小化・masking・retention・access controlが承認された例外だけに限定します。log accessもleast privilegeと監査を適用します。

---

## 17. AI & ベクトル検索戦略 (AI & Vector Search Strategy)

### Rule 17.1: The pgvector Architecture Protocol
-   **Law**: vector検索にはpgvector、managed vector service、search engine等を、scale、filter／authorization、latency、recall、freshness、operations、cost、exitから選びます。pgvectorはdata localityが価値を持つ候補です。
-   **Action**:
    1.  **Extension Enable**: `CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA extensions;` でpgvectorを有効化してください。`public` スキーマへのインストールは §2.2（Schema Separation）に違反します。
    2.  **Vector Contract**: provider／model、model revision、dimension、distance metric、normalization、source versionをmetadataとして契約し、current model dimensionを実装時に確認します。
        ```sql
        ALTER TABLE public.documents
        ADD COLUMN embedding vector(1536);
        ```
    3.  **Distance Metric**: cosine、inner product、L2等はmodel training contractとoffline／online評価から選び、単一metricをUniversal既定にしません。
    4.  **RLS Integration**: Embeddingカラムを含むテーブルにもRLSを必ず適用してください。ベクトル検索結果がRLSを迂回する設計（`service_role`での直接検索→クライアントへの無検証返却）は禁止です。

### Rule 17.2: The Vector Index Strategy
-   **Law**: ベクトルのインデックスは、データサイズと検索精度の要件に基づいて適切な型を選択しなければなりません。
-   **Action**:
    1.  **HNSW Candidate**: recall、latency、build time、memory、write rateの測定が適合する場合に選びます。
        ```sql
        CREATE INDEX idx_documents_embedding ON public.documents
        USING hnsw (embedding vector_cosine_ops)
        WITH (m = 16, ef_construction = 64);
        ```
    2.  **IVFFlat Candidate**: training data、memory、update patternが適合する場合に選び、lists／probesはbenchmarkで調整します。
    3.  **Index Lifecycle**: representative corpusとfilter selectivityでexact searchとのrecall、p95/p99、memory、build／rebuild costを測定し、作成・tuning・reindex時点を決めます。

### Rule 17.3: The RAG Pipeline Protocol
-   **Law**: RAG（Retrieval-Augmented Generation）パイプラインを構築する場合、Embeddingの生成・保存・検索・取得の全工程を一貫した設計で管理しなければなりません。
-   **Action**:
    1.  **Embedding Generation**: Embeddingの生成はEdge Functionまたはサーバーサイドで実行してください。クライアントからの直接API呼び出し（OpenAI APIキーの露出）は厳禁です。
    2.  **Chunk Strategy**: content構造、model context、retrieval unit、citation、overlap、languageからchunkingを評価し、固定token幅をUniversalへ置きません。
    3.  **Metadata Co-Storage**: Embeddingと一緒に**元テキスト・ソースURL・チャンク位置**をメタデータとして同一テーブルに保存してください。Embeddingのみ保存して元データを別管理すると、検索結果から原文を復元できなくなります。
    4.  **Authorized Retrieval**: RLS、security-invoker RPC、service boundary、pre-filter／post-filter等から、検索候補と返却結果の双方でauthorizationを証明できる方式を選びます。`SECURITY DEFINER`を既定にしません。
        ```sql
        CREATE OR REPLACE FUNCTION public.match_documents(
          query_embedding vector(1536),
          match_threshold float DEFAULT 0.78,
          match_count int DEFAULT 10
        )
        RETURNS TABLE (id uuid, content text, similarity float)
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = ''
        AS $$
        BEGIN
          RETURN QUERY
          SELECT d.id, d.content, 1 - (d.embedding <=> query_embedding) AS similarity
          FROM public.documents d
          WHERE 1 - (d.embedding <=> query_embedding) > match_threshold
          ORDER BY d.embedding <=> query_embedding
          LIMIT match_count;
        END;
        $$;
        ```
    5.  **Embedding Freshness**: source hash、model revision、generation status、retry、backfill、staleness SLOを記録し、意味変更時に再生成します。metadata-only変更まで無条件に再生成しません。

---

## 18. Auth高度設計戦略 (Advanced Auth Design Strategy)

### Rule 18.1: The API Key Security Protocol
-   **Law**: **Publishable Key**、**Secret Key**、legacy `anon`／`service_role` key、user JWT、JWT signing keyを別credential classとして台帳化し、client exposure、RLS、rotation、revocation、consumer、migrationを管理します。
-   **Action**:
    1.  **Publishable Key**: browser、mobile、desktop等へ配布可能ですが、authorizationではありません。exposed schemaのRLS、least-privilege grants、abuse control、data classificationを必須とします。
    2.  **Secret Key**: server、worker、Edge Function等のtrusted runtimeだけで使用し、client bundle、log、preview、user-controlled headerへ露出しません。RLS bypass相当のblast radiusを前提にworkload別key、最小利用、rotation、auditを設計します。
    3.  **Legacy Migration**: legacy `anon`／`service_role` keyの現行deprecation期限を公式文書で追跡し、publishable／secret keyへconsumer単位で移行して、利用telemetry確認後にlegacy keyを無効化します。
    4.  **Key Rotation**: 漏洩疑いでは検知serviceによる自動失効に依存せず、即時revoke／rotate、consumer更新、log／data access調査、incident evidence保存を行います。
    5.  **JWT Verification**: API keyとJWT signing keyを混同しません。外部serviceはcurrent JWKS／asymmetric signing contract、issuer、audience、expiry、key rotationを検証し、共有high-privilege API keyをtoken verificationへ流用しません。
    6.  **Data API Exposure**: Data APIを使わないarchitectureでは無効化またはexposed schemaを限定します。使う場合は新tableの自動公開を仮定せず、exposure、grant、RLSをmigrationとtestで管理します。

### Rule 18.2: The PKCE & MFA Implementation Protocol
-   **Law**: 認証フローにおいて、**PKCE（Proof Key for Code Exchange）** を標準とし、高セキュリティが求められるアプリケーションでは**MFA（Multi-Factor Authentication）** を実装しなければなりません。
-   **Action**:
    1.  **PKCE Default**: Supabase Authは PKCE フローをネイティブサポートしています。`supabase.auth.signInWithOAuth()` はデフォルトでPKCEを使用します。カスタム実装で `code_verifier` / `code_challenge` を手動管理する場合は、RFC 7636に厳密に従ってください。
    2.  **MFA Enrollment**: `supabase.auth.mfa.enroll({ factorType: 'totp' })` でMFAを登録。QRコードをユーザーに表示し、TOTP アプリ（Google Authenticator等）での認証を推奨。
    3.  **MFA Verification**: ログイン後、`supabase.auth.mfa.getAuthenticatorAssuranceLevel()` で `currentLevel` を確認し、`aal1`（パスワードのみ）と `aal2`（MFA完了）を区別してください。
    4.  **AAL-Based RLS**: 高セキュリティテーブル（決済、個人情報等）のRLSポリシーに `auth.jwt()->>'aal' = 'aal2'` を条件追加し、MFA完了ユーザーのみアクセスを許可してください。
        ```sql
        CREATE POLICY "require_mfa_for_payments" ON public.payments
        FOR ALL USING (
          (select auth.uid()) = user_id
          AND (select auth.jwt()->>'aal') = 'aal2'
        );
        ```
    5.  **Phone MFA**: SMS認証は SIM スワップ攻撃のリスクがあります。可能な限りTOTPを優先し、SMS MFAは代替手段として位置づけてください。

### Rule 18.3: The Anonymous Auth & Session Management Protocol
-   **Law**: Supabase Anonymous Auth を使用する場合は、匿名ユーザーのデータ管理とアカウント昇格（リンキング）のライフサイクルを設計しなければなりません。
-   **Action**:
    1.  **Anonymous Auth Use Case**: ゲストカート、オンボーディング体験、デモ機能等、認証なしで一時的なDB書き込みが必要な場合に使用。
    2.  **Account Linking**: 匿名ユーザーが後からメール/SNSでサインアップする場合、`supabase.auth.linkIdentity()` で既存の匿名セッションに新しい認証情報を紐付け、データの連続性を保証してください。
    3.  **RLS for Anonymous**: 匿名ユーザー向けのRLSポリシーでは、`auth.jwt()->>'is_anonymous'` で匿名と認証済みユーザーを区別し、書き込み範囲を制限してください。
    4.  **Cleanup**: 昇格されない匿名identityはpurpose、fraud、legal hold、user expectation、provider billingからretentionを決め、承認済みschedulerで削除／匿名化します。固定30日や`pg_cron`をUniversalへ置きません。
    5.  **Session Refresh**: `supabase.auth.onAuthStateChange()` でセッション状態の変更を監視し、トークン更新を適切に処理してください。トークン期限切れの放置は、ユーザーの突然のログアウトを引き起こします。

---

## 19. テスト戦略 (Testing Strategy)

### Rule 19.1: The RLS Policy Testing Protocol
-   **Law**: RLS policyは自動testで検証し、manual確認だけに依存しません。test artifactはmigrationと同じchange setでversion管理しますが、production migration fileへの混在を一律要求しません。
-   **Action**:
    1.  **pgTAP Integration**: `pgTAP` 拡張を使用してRLSポリシーの単体テストを記述してください。
        ```sql
        -- pgTAPによるRLSテスト例
        BEGIN;
        SELECT plan(2);

        -- ユーザーAとして認証
        SET LOCAL role = 'authenticated';
        SET LOCAL request.jwt.claims = '{"sub": "user-a-uuid", "role": "authenticated"}';

        -- 自分のデータは読める
        SELECT results_eq(
          $$SELECT count(*) FROM public.posts WHERE user_id = 'user-a-uuid'$$,
          ARRAY[1::bigint],
          'User A can read own posts'
        );

        -- 他人のデータは読めない
        SELECT results_eq(
          $$SELECT count(*) FROM public.posts WHERE user_id = 'user-b-uuid'$$,
          ARRAY[0::bigint],
          'User A cannot read User B posts'
        );

        SELECT * FROM finish();
        ROLLBACK;
        ```
    2.  **Role Impersonation**: テスト内で `SET LOCAL role = 'anon'` / `'authenticated'` / `'service_role'` を使用し、各ロールでのアクセス可否を検証してください。
    3.  **Negative Testing**: ポリシーが「拒否すべきアクセスを正しく拒否している」ことの検証（ネガティブテスト）を必ず含めてください。「許可すべき操作が通る」ことだけでは不十分です。
    4.  **CI Integration**: pgTAPテストを CI/CD パイプライン（GitHub Actions等）に統合し、マイグレーション適用後に自動実行してください。

### Rule 19.2: The Edge Functions Testing Protocol
-   **Law**: Edge Functionsは**ローカルテスト**と**統合テスト**の2層で検証しなければなりません。
-   **Action**:
    1.  **Unit Test**: Deno標準のテストランナー（`deno test`）を使用し、Edge Function内のビジネスロジックを単体テストしてください。外部依存（DB、外部API）はモックに置き換えてください。
    2.  **Integration Test**: `supabase functions serve` でローカル起動した Edge Function に対して、実際のHTTPリクエストを送信して動作確認してください。認証ヘッダー付きリクエストとヘッダーなしリクエストの両方をテストしてください。
    3.  **Error Scenarios**: 正常系だけでなく、認証失敗、入力バリデーションエラー、外部API障害時のレスポンスを検証してください。
    4.  **Supabase CLI Test**: `supabase functions test` コマンド（利用可能な場合）で自動テストを実行してください。

### Rule 19.3: The Database Function Testing Protocol
-   **Law**: カスタムRPC関数（PL/pgSQL）は、入力パラメータの境界値テスト・権限テスト・エラーハンドリングテストを網羅しなければなりません。
-   **Action**:
    1.  **Boundary Value Testing**: NULL入力、空文字列、極端に大きな数値、不正なUUIDなどの境界値に対する関数の挙動をテストしてください。
    2.  **Permission Testing**: `SECURITY DEFINER` 関数は、意図しない権限昇格が起きていないか検証してください。`anon` ロールから呼び出した場合に、本来アクセスできないデータを返していないか確認してください。
    3.  **Transaction Safety**: 関数内でエラーが発生した場合に、部分的なデータ変更が残らず適切にロールバックされることを確認してください。
    4.  **Seed Data**: test fixtureは承認済みseed file、factory、snapshot等で決定的に構築し、production dataや固定pathに依存しません。

---

## 20. マルチ環境 & ブランチング戦略 (Multi-Environment & Branching Strategy)

### Rule 20.1: The Environment Isolation Protocol
-   **Law**: production trust boundaryは非本番から分離します。dev、test、preview、stagingの物理project数はdata class、blast radius、parallelism、cost、provider capabilityから決め、production credential／dataを共有しません。
-   **Action**:
    1.  **Isolation Pattern**: independent project、branch／preview instance、ephemeral local stack等から必要なisolationを選び、productionだけは独立したaccess・secret・approval boundaryを持たせます。
    2.  **Environment Variable Isolation**: 各環境の `SUPABASE_URL` と `SUPABASE_ANON_KEY` は環境変数で厳格に管理し、ハードコードを禁止してください。
    3.  **Production Data Isolation**: 本番データを開発/ステージング環境にコピーする場合は、PII（個人情報）を**必ず匿名化・マスキング**してください。本番データの無加工コピーはAPPI/GDPR違反のリスクです。
    4.  **Migration Flow**: マイグレーションの適用順序は `Dev → Staging → Production` の一方向です。Productionへの非管理変更は §7.6（Controlled Remote Change Policy）により禁止されています。
    5.  **Seed Data Separation**: 各環境のシードデータ（`seed.sql`）は環境別に管理し、開発用テストデータが本番に混入することを防いでください。

### Rule 20.2: The Supabase Branching Protocol
-   **Law**: current planとmaturityが適合する場合はSupabase Branching、preview project、local ephemeral stack等でschema changeを隔離検証します。preview機能の採用自体をUniversal要件にしません。
-   **Action**:
    1.  **Branch = Isolated Instance**: 各ブランチは独立したSupabaseインスタンス（独自のAPIクレデンシャル、Auth、Storage）として機能します。本番環境に影響を与えずにスキーマ変更をテストできます。
    2.  **Dashboard / CLI Creation**: ブランチはSupabaseダッシュボード、CLI（`supabase branches create`）、またはManagement APIから作成可能です。Git連携は必須ではありません（Branching 2.0）。
    3.  **Migration Preview**: ブランチでマイグレーションを適用し、スキーマの整合性・RLSポリシーの動作・パフォーマンスへの影響を本番適用前に検証してください。
    4.  **Branch Lifecycle**: テスト完了後のブランチは速やかに削除してください。放置されたブランチはコンピュートリソースを消費し、コスト増の原因となります。
    5.  **No Data Persistence**: ブランチは一時的な検証環境です。ブランチ内のデータはマージ時に本番へ移行されません。テストデータのみ使用し、重要なデータをブランチに保存しないでください。

---

## 21. PostgREST API設計戦略 (PostgREST API Design Strategy)

### Rule 21.1: The Select Optimization Protocol
-   **Law**: public、large、high-frequencyなPostgREST queryはfieldとresultをboundedにします。明示的な小規模contractでは`select('*')`を許容できますが、schema expansion、PII、egressをtestします。
-   **Action**:
    1.  **Explicit Select**: `.select('id, name, created_at')` のように必要カラムを明示してください。`select('*')` は転送データ量を増大させ、Bandwidth課金に直結します（§16.3参照）。
    2.  **Computed Columns**: PostgreSQLの Generated Columns やViewを活用し、API経由で計算結果を直接返却してください。クライアント側での再計算を低減します。
    3.  **Type Contract**: DB schemaまたはgenerator versionが変わる場合は生成型を更新し、`select()`の変更時はquery result inference、DTO、consumer contract、contract testの整合性を検証してください。select listだけの変更をDB schema型の再生成理由と混同しません。

### Rule 21.2: The Filtering & Embedding Protocol
-   **Law**: unbounded dataはsource側で絞り込み、Embedding、複数query、RPC、service aggregationをcardinality、payload、cacheability、latency、authorization境界から選びます。1 request化やEmbedding自体を目的にしません。
-   **Action**:
    1.  **Filter Operators**: `.eq()`, `.in()`, `.gte()`, `.lte()`, `.like()`, `.ilike()` などのPostgRESTフィルタを活用し、サーバーサイドでデータを絞り込んでください。全件取得してクライアント側でフィルタリングする設計は禁止です。
    2.  **Embedding Candidate**: boundedな関連データを同じauthorizationとcache境界で返す場合、外部キーEmbeddingは有力候補です。独立cache、異なる更新頻度、巨大fan-out、別権限境界がある場合は複数queryや専用endpointを比較してください。
        ```typescript
        // ✅ 1リクエストでpostsとauthorの情報を取得
        const { data } = await supabase
          .from('posts')
          .select('id, title, author:profiles(name, avatar_url)')
          .eq('status', 'published');
        ```
    3.  **Inner Join**: デフォルトはLeft Joinです。関連レコードが必ず存在すべき場合は `!inner` 修飾子で Inner Join を指定し、NULLの混入を防いでください。
        ```typescript
        .select('id, title, author:profiles!inner(name)')
        ```
    4.  **Nesting Budget**: 固定階層数ではなく、実行計画、row fan-out、serialized payload、memory、timeout、egress budgetを測定して許容深度を決めます。budgetを超えるnested contractはview、RPC、複数取得、事前集約へ分解してください。

### Rule 21.3: The Pagination & Aggregate Protocol
-   **Law**: 増加し得る、または上限を証明できないcollectionはbounded pagination、stream、export job等を実装します。小さく上限管理されたreference dataまで一律にpaginationを強制しません。
-   **Action**:
    1.  **Range Pagination**: `.range(from, to)` でオフセットベースのページネーションを実装してください。レスポンスヘッダー `Content-Range` で総件数を取得可能です。
    2.  **Count Option**: 総件数が必要な場合は `{ count: 'exact' }` オプションを使用してください。ただし、大量データのテーブルでは `count: 'estimated'` を推奨します（`exact` は全行スキャンが発生）。
    3.  **Cursor Pagination**: collectionの成長、深いpage、並行更新、安定順序が要件になる場合は、unique tie-breakerを含むKeyset Paginationを候補にします。固定行数を境界にせず、実行計画とconsistency testでoffset方式と比較してください。
    4.  **Page Budget**: page sizeは実効provider limit、payload、client memory、latency SLO、egress、rate limitからBlueprintで決め、server-side maximumとtestで強制します。Universalに固定件数を埋め込みません。

---

## 22. CLI & ローカル開発戦略 (CLI & Local Development Strategy)

### Rule 22.1: The CLI-First Workflow Protocol
-   **Law**: Supabase CLIを開発ワークフローの中心に据え、ダッシュボードGUI操作への依存を最小化しなければなりません。
-   **Action**:
    1.  **Local Development**: `supabase init` → `supabase start` でローカル開発環境を構築してください。ローカル環境では本番と同一のPostgreSQL・Auth・Storage・Edge Functionsが動作します。
    2.  **Migration Workflow**: スキーマ変更は `supabase migration new <name>` で新規マイグレーションファイルを作成し、SQLを記述してください。remote consoleからの非管理変更は §7.6（Controlled Remote Change Policy）により禁止です。
    3.  **Linking**: リモートプロジェクトとの連携は `supabase link --project-ref <ref>` で設定してください。
    4.  **Type Generation**: `supabase gen types typescript --local > src/types/database.types.ts` でローカルDBから型定義を生成してください。リモートDBからの生成は `--project-id` オプションで可能です。
    5.  **Deploy**: Edge Functionsのデプロイは `supabase functions deploy <name>` で実行してください。`--no-verify-jwt` オプションは §13.2 により開発時のみ許可です。

### Rule 22.2: The Database Inspection & Diff Protocol
-   **Law**: スキーマの状態確認・差分検出にはSupabase CLIの**inspect & diff**コマンドを活用し、手動確認の工数を削減しなければなりません。
-   **Action**:
    1.  **`supabase db diff`**: ローカルDBとマイグレーション履歴の差分を検出してください。ダッシュボードで手動変更した場合の差分検出に有効です。
    2.  **`supabase inspect db`**: テーブルサイズ、インデックス使用状況、不要インデックスの検出等、データベースの健全性を検査してください。§16.1（Database Performance Monitoring Protocol）と組み合わせて定期的に実行してください。
    3.  **`supabase db lint`**: スキーマのLintチェックを実行し、§0.1（Zero Tolerance Linter Protocol）の自動化してください。CI/CDパイプラインに組み込み、マイグレーション適用前に自動チェックすることを推奨します。
    4.  **`supabase db reset`**: ローカル環境のDBを完全リセットし、全マイグレーションを再適用します。テスト環境のクリーンな状態を確保するために定期的に実行してください。
    5.  **Version Pinning**: `supabase/config.toml` でローカル環境のPostgreSQLバージョンを本番と一致させてください。バージョン不一致はマイグレーション互換性の問題を引き起こします。

---

## 23. Connection Pooling / Supavisor戦略

### Rule 23.1: The Supavisor Architecture Protocol
-   **Law**: runtime concurrency、connection lifetime、network reachability、session semantics、provider capabilityからData API、pooler、direct connectionを選びます。Supavisorはelastic／short-lived workloadの有力候補であり、全経路への一律要件ではありません。
-   **Action**:
    1.  **Endpoint Contract**: endpoint、port、TLS、IPv4／IPv6、pooling mode、credential、prepared statement互換性はcurrent project設定と公式資料から取得し、固定portをUniversalへ置きません。
    2.  **Serverless Optimization**: サーバーレス環境（Vercel Functions, Edge Functions等）では、リクエストごとにDB接続が生成・破棄されます。Supavisorは**ホットコネクション**をプール管理し、接続のオーバーヘッド（TCP handshake, TLS negotiation, PostgreSQL startup）を大幅に削減します。
    3.  **IPv6 Mediation**: Supavisorは IPv4 → IPv6 のメディエーションを提供します。GitHub Actions等のIPv4環境からの接続はPooler経由で行い、IPv6接続エラーを回避してください。
    4.  **Replica Routing Verification**: Read Replicaを採用する場合は、現在の契約plan、接続endpoint、client、pooling modeが提供するrouting挙動を公式仕様と実測で確認してください。自動分散を仮定せず、primary／replicaの経路、read-after-write整合性、failover時挙動をテストします。

### Rule 23.2: The Pool Size Design Protocol
-   **Law**: コネクションプールのサイズは、PostgreSQLの最大接続数とアプリケーションの特性に基づいて**計算式で設計**しなければなりません。デフォルト値の放置を禁止します。
-   **Action**:
    1.  **Pool Size Calculation**: peak instance数、per-instance concurrency、transaction duration、database／pooler capacity、migration／operator／replication headroomからpool budgetを計算し、load testでqueue timeとsaturationを検証します。
    2.  **Max Connections Awareness**: 実効`max_connections`、pooler上限、reserved connection、contract planをruntime evidenceから確認し、plan名ごとの固定値を埋め込みません。
    3.  **Connection Monitoring**: ダッシュボードの **Database > Connections** ページで接続数推移を定期的に監視してください。Teams/Enterpriseプランでは接続種別（Postgres, PostgREST, Auth, Storage等）ごとの内訳が確認可能です。
    4.  **Connection Leak Prevention**: アプリケーション側で `supabase.removeAllChannels()` やDB接続の明示的クローズを忘れると、コネクションリークが発生します。サーバーレス関数では必ずリクエスト完了時に接続を解放してください。

### Rule 23.3: The Connection Mode Decision Protocol
-   **Law**: アプリケーションの特性に応じて、**Transaction Mode**と**Session Mode**を正しく使い分けなければなりません。
-   **Action**:
    1.  **Transaction Mode Candidate**: short-lived／elastic workloadでsession stateが不要な場合の候補です。driverとprepared statementのcurrent互換性をtestします。
    2.  **Session Mode**: Prepared Statementsや`LISTEN/NOTIFY`など、セッション状態に依存する機能が必要な場合のみ使用してください。コネクションはセッション終了まで占有されます。
    3.  **Transaction Mode制約**: Transaction Modeでは以下の機能が**使用不可**です:
        -   `SET` コマンドによるセッション変数
        -   `PREPARE` / `DEALLOCATE`（Prepared Statements）- ただしSupavisor 1.0+の Named Prepared Statement対応で一部緩和
        -   `LISTEN` / `NOTIFY`
        -   Advisory Locks
    4.  **Direct Connection（ポート5432）**: マイグレーションの実行、`pg_dump`、長時間実行クエリなど、プーラー経由では不適切な操作には直接接続を使用してください。

---

## 24. バックアップ & 災害復旧戦略 (Backup & Disaster Recovery Strategy)

### Rule 24.1: The Backup Strategy Protocol
-   **Law**: 本番環境のデータと復旧に必要な全resourceを、定義済みRPO／RTO、retention、failure domain、data classificationに適合する検証可能なbackup戦略で保護します。単一control plane、単一account、単一regionへの依存はrisk assessmentで明示し、必要な冗長性を設計します。
-   **Action**:
    1.  **Effective Capability Inventory**: 契約planと現行公式文書を確認し、backup frequency、retention、PITR、download／export、restore方式、暗号化、region、権限を実効設定と証跡で台帳化します。固定plan名や保持日数を規約へ埋め込みません。
    2.  **Resource-complete Scope**: database backupがStorage object、Auth設定、Edge Functions、secret、network、custom domain、外部identity／queueを含むと仮定せず、resourceごとの保護・再構築・整合順序を定義します。
    3.  **Independent Copy When Required**: provider account削除、control-plane障害、region障害、誤操作、ransomwareを脅威モデルに含む場合、承認済みschedulerと暗号化された別failure domainへlogical／physical exportを保存し、immutabilityとdelete protectionを検討します。
    4.  **Privacy and Key Separation**: PIIを含むbackupはdata classificationに従って暗号化、access logging、retention、legal hold、deletion、key separationを適用します。
    5.  **Continuous Evidence**: backup job、freshness、size anomaly、restore eligibilityを監視し、失敗をownerへ通知します。成功表示だけをrecoverabilityの証明にしてはなりません。

### Rule 24.2: The Disaster Recovery Planning Protocol
-   **Law**: 災害復旧（DR）手順は**文書化・テスト済み**でなければなりません。「復旧手順が存在しない」「テストされていない」状態での本番運用を禁止します。
-   **Action**:
    1.  **RTO/RPO Definition**: business impact、data loss tolerance、dependency chain、規制からservice／data domainごとのRTOとRPOをBlueprintで定義し、provider機能の実測値で達成可能性を検証します。
    2.  **Recovery Runbook**: 以下を含む復旧手順書を作成し、チームで共有してください:
        -   承認済みcontrol plane、APIまたはCLIからの復元手順
        -   `pg_restore` によるバックアップからの復元手順
        -   PITRの時点指定復元手順
        -   Auth/Storage/Edge Functionsを含む全サービスの復旧チェックリスト
    3.  **DR Test**: release risk、change event、compliance、RTO／RPOに応じたcadenceで隔離環境へ実復元し、data integrity、identity、Storage object、application、observability、DNS／routingまで検証します。未テストbackupをrecoverableと表現してはなりません。
    4.  **Recovery Priority**: data domainとdependency graphに基づく復旧順序、parallelism、整合checkpointをBlueprintへ定義します。固定tierや固定時間を全projectへ強制しません。
    5.  **Incident Communication**: 障害発生時のコミュニケーション手順（ユーザー通知、ステークホルダー連絡、ステータスページ更新）も復旧手順書に含めてください。

---

## 25. Rate Limiting & API保護戦略 (Rate Limiting & API Protection Strategy)

### Rule 25.1: The Auth Rate Limiting Protocol
-   **Law**: Supabase Authのビルトインレート制限を理解し、アプリケーション設計に組み込まなければなりません。レート制限を無視した設計は、正規ユーザーのブロックやサービス拒否を引き起こします。
-   **Action**:
    1.  **Effective Limits**: Authのcurrent default、project override、provider quotaをDashboard／Management API／公式資料から取得し、email、SMS、signup、token等のdimensionごとにcapacityとabuse budgetを設計します。
    2.  **Management API Customization**: ダッシュボードまたはManagement APIを通じてレート制限値をカスタマイズしてください。デフォルト値はスタートアップ向けであり、トラフィックの増加に応じて調整が必要です。
    3.  **Client-Side Throttling**: クライアント側でも認証リクエストにスロットリングを実装してください。ボタンの連打やリトライループによる不必要なレート制限超過を低減します。
    4.  **Error Handling**: レート制限超過時のHTTP 429レスポンスを適切にハンドリングしてください。ユーザーに「しばらくお待ちください」等のメッセージを表示し、`Retry-After` ヘッダーに基づいてリトライタイミングを制御してください。

### Rule 25.2: The Custom API Rate Limiting Protocol
-   **Law**: internet-facingまたはcost-amplifyingなData API／Functionには、provider control、gateway、distributed store、database等から適切なrate／concurrency／quota controlを設けます。
-   **Action**:
    1.  **Control Selection**: exactness、distribution、latency、failure mode、costからtoken bucket、sliding window、concurrency limit、quota等を選びます。Upstash等は非規範例です。
        ```typescript
        // Edge Function内でのRate Limiting例
        import { Ratelimit } from "@upstash/ratelimit";
        import { Redis } from "@upstash/redis";

        const ratelimit = new Ratelimit({
          redis: Redis.fromEnv(),
          limiter: Ratelimit.slidingWindow(10, "60 s"), // 60秒間に10リクエスト
        });

        const { success } = await ratelimit.limit(identifier);
        if (!success) return new Response("Rate limited", { status: 429 });
        ```
    2.  **Identity and Fairness**: IP、account、tenant、device、credential、resourceをprivacy、NAT、evasion、enterprise fairnessから組み合わせます。
    3.  **Resource Budget**: endpointごとのCPU、DB rows、egress、downstream quota、business tierからlimitを設定し、固定requests-per-minuteをUniversalへ置きません。
    4.  **Abuse Detection**: 異常なパターン（短時間に大量のサインアップ、同一IPからの連続ログイン失敗等）を検出し、一時的なIPブロックまたはCAPTCHAチャレンジを発動するロジックを実装してください。

---

## 26. Vault & シークレット管理戦略 (Vault & Secret Management Strategy)

### Rule 26.1: The Vault Encrypted Storage Protocol
-   **Law**: secretは用途とexecution boundaryに適した承認済みsecret manager、workload identity、platform secret、またはVaultで暗号化、least privilege、rotation、auditを実現します。source code、client bundle、log、平文DBへの保存は禁止します。
-   **Action**:
    1.  **Vault Extension**: Supabase Vaultは**Authenticated Encryption**でシークレットを暗号化保存します。ダッシュボードの「Vault」セクションまたはSQLでシークレットを管理してください。
        ```sql
        -- シークレットの保存
        SELECT vault.create_secret('my-api-key-value', 'stripe_api_key', 'Stripe本番APIキー');

        -- シークレットの取得（復号化ビュー経由）
        SELECT * FROM vault.decrypted_secrets WHERE name = 'stripe_api_key';
        ```
    2.  **Statement Logging Disable**: シークレット挿入時は `SET LOCAL log_statement = 'none';` でログに平文が記録されることを防止してください。これを失念するとログファイルにシークレットが残存します。
    3.  **Access Restriction**: `vault.decrypted_secrets` ビューへのアクセスは、必要最小限のロール（`service_role` または専用の管理ロール）に制限してください。`anon` や `authenticated` ロールからの直接アクセスを禁止します。
    4.  **Lifecycle Compatibility**: extension／providerのdeprecationとmigration pathをcurrent公式資料で確認し、内部実装が透過的に移行すると仮定しません。
    5.  **Boundary Selection**: database内実行だけが必要なsecretはVault候補、Function／CI／external workloadは各runtimeのapproved secret bindingまたはworkload identity候補です。

### Rule 26.2: The Secret Rotation & Lifecycle Protocol
-   **Law**: シークレットは**定期的にローテーション**し、漏洩時は即座に無効化しなければなりません。ローテーション手順が文書化されていない状態を禁止します。
-   **Action**:
    1.  **Rotation Schedule**: keyless／short-lived credentialを優先し、長期secretは種類、漏洩影響、provider capability、規制、consumer更新時間からBlueprintのrotation／revocation cadenceを決めます。漏洩疑いでは定期日を待たず失効します。
    2.  **Automated Rotation**: 可能な限りシークレットローテーションを自動化してください。Vault内のシークレット更新 → 依存するFunctions/Triggersの動作確認 → 旧シークレットの無効化、の順序で実行します。
    3.  **Leak Response**: Supabaseは2025年から**GitHub公開リポジトリにプッシュされたAPIキーを自動検出・無効化**する機能を提供しています。この機能に依存せず、`.env` ファイルのgitignore設定と、CI/CDでのシークレットスキャン（GitHub Secret Scanning, GitLeaks等）を必ず実施してください。
    4.  **Environment Separation**: 開発/ステージング/本番のシークレットは完全に分離してください。同一のAPIキーを複数環境で共有することを禁止します。
    5.  **Audit Trail**: シークレットの作成・更新・削除の履歴を追跡可能にしてください。Vault操作時にaudit_logsテーブルにイベントを記録することを推奨します。

---

## 27. Foreign Data Wrappers (FDW) 戦略

### Rule 27.1: The FDW Architecture Protocol
-   **Law**: 外部data source統合では、FDW／Supabase Wrappers、API、event ingestion、ETL／ELT、replicationを、consistency、latency、credential isolation、query pushdown、rate limit、failure propagation、cost、portabilityで比較します。Wrappersは候補であり一律要件ではありません。
-   **Action**:
    1.  **SQL-Native Access**: FDWにより外部APIやデータベースを通常のPostgreSQLテーブルと同様にSQLで操作できます。アプリケーション側での個別API呼び出しロジックを削減し、データアクセスの統一性を確保してください。
    2.  **Supported Wrappers**: 以下の主要FDWが利用可能です:
        -   **Stripe**: 決済データの読み取り・書き込み
        -   **Firebase**: Auth Users / Firestore Documents の読み取り
        -   **S3**: CSV / JSON Lines / Parquet ファイルの読み取り
        -   **ClickHouse / BigQuery**: 分析データへのアクセス
        -   **PostgreSQL**: 他のPostgreSQLインスタンスへの接続
    3.  **Wasm FDW**: Supabaseは**WebAssembly版FDW**をサポートしており、サンドボックス環境での安全な実行とカスタムFDWの開発を可能にします。新規FDWの開発にはWasm FDWを推奨します。
    4.  **ETL不要**: FDWはデータを元のソースに保持したままアクセスするため、ETLパイプラインの構築が不要です。ただし、レイテンシーとデータ鮮度のトレードオフを理解してください。

### Rule 27.2: The FDW Security & Performance Protocol
-   **Law**: FDW credentialは承認済みsecret boundaryで保護し、foreign objectのAPI exposureとgrantを最小化します。cache／materializationはlatency、freshness、consistency、costの測定時だけ採用します。
-   **Action**:
    1.  **Credential Integration**: credentialをSQL source、migration、SERVER option、logへ平文で埋め込まず、extensionが対応するapproved secret referenceまたはisolated execution boundaryを使用します。
        ```sql
        -- Vault にシークレット保存
        SELECT vault.create_secret('sk_live_xxx', 'stripe_api_key');
        -- FDW作成時にVault参照
        CREATE SERVER stripe_server
          FOREIGN DATA WRAPPER stripe_wrapper
          OPTIONS (api_key_id (SELECT id FROM vault.decrypted_secrets WHERE name = 'stripe_api_key'));
        ```
    2.  **Private Schema Placement**: 外部テーブルは`public`スキーマや公開APIスキーマに配置**しないでください**。専用のプライベートスキーマ（例: `fdw_stripe`, `fdw_firebase`）に配置し、Data API経由の直接アクセスを遮断してください。
    3.  **Materialization Choice**: query cache、materialized view、replication、ETL等からfreshness SLO、failure recovery、source quotaに合う方式を選びます。
    4.  **Controlled Exposure**: security-invoker view／function、constrained service、materialized projection等から必要fieldとrowだけを公開し、`SECURITY DEFINER`を既定にしません。
    5.  **Error Handling**: 外部APIの障害（レート制限、ネットワークエラー）がPostgreSQLクエリのタイムアウトに波及します。FDW経由のクエリには`statement_timeout`を設定し、障害の伝播を防止してください。

---

## 28. Data API Hardening戦略 (Data API Hardening Strategy)

### Rule 28.1: The Schema Exposure Control Protocol
-   **Law**: PostgREST Data APIが公開するスキーマを**最小限に制限**し、不要なテーブル・関数の露出を防止しなければなりません。
-   **Action**:
    1.  **Custom API Schema**: デフォルトの`public`スキーマを直接APIに公開する代わりに、専用のAPIスキーマ（例: `api`）を作成し、公開すべきビューと関数のみをこのスキーマに配置してください。
        ```sql
        CREATE SCHEMA api;
        -- 公開すべきビューのみをapiスキーマに作成
        CREATE VIEW api.public_posts AS
          SELECT id, title, content, created_at
          FROM public.posts
          WHERE status = 'published';
        ```
    2.  **Exposed Schemas Configuration**: ダッシュボードの「API Settings > Exposed schemas」で公開スキーマを設定してください。`public`を含める場合でも、テーブル単位でRLSとGRANTで厳密にアクセス制御してください。
    3.  **Internal Tables隠蔽**: マイグレーション管理テーブル、監査ログ、内部設定テーブル等は**APIに公開しないでください**。これらは`internal`等の非公開スキーマに配置します。
    4.  **Function Exposure**: `public`スキーマの全関数がRPC経由で呼び出し可能になります。内部専用の関数は非公開スキーマに移動するか、`GRANT`で`anon`/`authenticated`ロールからのEXECUTE権限を剥奪してください。

### Rule 28.2: The Network Schema & OpenAPI Lockdown Protocol
-   **Law**: PostgreSQLからの外部HTTP通信を制御する`http`/`net`スキーマ、およびOpenAPIメタデータの不正利用を防止しなければなりません。
-   **Action**:
    1.  **Network Schema Revocation**: `http`拡張機能（`http_get`, `http_post`等）および`net`スキーマ（`net.http_get`等）への`anon`/`authenticated`ロールのアクセスを**取り消してください**。これらがデフォルトで公開されていると、SQLインジェクション経由でサーバーサイドリクエストフォージェリ（SSRF）が成立するリスクがあります。
        ```sql
        -- http拡張のアクセス制御
        REVOKE ALL ON SCHEMA net FROM anon, authenticated;
        REVOKE ALL ON ALL FUNCTIONS IN SCHEMA net FROM anon, authenticated;
        ```
    2.  **OpenAPI Endpoint**: PostgRESTは`/rest/v1/`エンドポイントでOpenAPIスキーマを自動公開します。本番環境では、OpenAPIの公開が不要な場合は**ロール単位で無効化**してください（`ALTER ROLE authenticator SET pgrst.openapi_mode = 'disabled'`）。
    3.  **Schema Introspection Defense**: 攻撃者がOpenAPIスキーマからテーブル構造・カラム名・関数シグネチャを推測する「偵察」を防止してください。OpenAPIを無効化できない場合は、公開スキーマに配置するオブジェクトを最小限にすることで攻撃面を縮小します。
    4.  **GRANT Audit**: 定期的に以下のクエリで`anon`/`authenticated`ロールの権限を監査してください:
        ```sql
        SELECT grantee, table_schema, table_name, privilege_type
        FROM information_schema.role_table_grants
        WHERE grantee IN ('anon', 'authenticated')
        ORDER BY table_schema, table_name;
        ```
    5.  **Principle of Least Privilege**: 全てのスキーマ、テーブル、関数、ビューに対して**最小権限の原則**を適用してください。デフォルトの`GRANT`設定を鵜呑みにせず、不要な権限は明示的に`REVOKE`してください。

---

## 29. Multi-tenancy戦略 (Multi-tenancy Strategy)

### Rule 29.1: The Tenant Isolation Design Protocol
-   **Law**: マルチテナントではshared-row RLS、schema分離、database／project分離、service境界等から脅威、規制、blast radius、運用、costに適合する強制境界を選びます。アプリケーションの任意filterだけに依存した分離は禁止します。
-   **Action**:
    1.  **Isolation Discriminator**: shared-row modelでは変更不能なtenant／organization discriminator、FK、index、RLSを整合させます。名前や型はdomainとidentity modelから選び、`tenant_id UUID`を唯一の表現にしません。次は例です。
        ```sql
        CREATE TABLE public.projects (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          tenant_id UUID NOT NULL,
          name TEXT NOT NULL,
          created_at TIMESTAMPTZ DEFAULT now()
        );
        -- tenant_idにインデックスを作成（RLSパフォーマンスに必須）
        CREATE INDEX idx_projects_tenant_id ON public.projects (tenant_id);
        ```
    2.  **Trusted Tenant Context**: RLSはsigned claim、membership relation、session context等のうち、revocation freshnessとconsistency要件を満たすauthoritative tenant contextを照合します。JWT `app_metadata`は候補ですが、stale claimとmembership変更を設計してください。次は単一tenant claimの例です。
        ```sql
        ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
        CREATE POLICY "tenant_isolation" ON public.projects
          FOR ALL
          USING (tenant_id = (auth.jwt() -> 'app_metadata' ->> 'tenant_id')::UUID);
        ```
    3.  **Membership Lifecycle**: tenant assignment、invitation、role変更、移管、退会、削除をauthoritative membership workflowで管理し、claim refresh、session revoke、audit、race conditionをtestします。
    4.  **Shared vs Dedicated**: shared-row、schema-per-tenant、database／project-per-tenant、hybridを、tenant数の固定閾値ではなくdata sensitivity、noisy-neighbor、backup／restore単位、residency、customization、SLO、運用人数、unit economicsで比較します。

### Rule 29.2: The Tenant Isolation Audit Protocol
-   **Law**: テナント分離は**定期的に監査・テスト**し、データ漏洩がないことを検証しなければなりません。
-   **Action**:
    1.  **Cross-Tenant Query Test**: テストスイートに「テナントAのユーザーがテナントBのデータにアクセスできないこと」を検証するテストケースを必ず含めてください。
    2.  **Isolation Coverage Check**: machine-readableなtenancy inventoryを正本とし、各resourceがdeclared model、discriminator／schema／database mapping、policy、index、negative test、ownerを持つことを検証します。固定名の`tenant_id`検索だけでcoverageを判定しません。
    3.  **RLS Enforcement Check**: `public`スキーマの全テーブルでRLSが有効化されているか定期的に監査してください（§3参照）。
    4.  **Tenant-Aware RBAC**: tenant内外の権限は、membership table、claim、RLS、policy service等からrevocationとconsistency要件に合うmodelを選びます。cross-tenant操作は通常user pathから分離し、resource／action scope、step-up、time-bound approval、監査を備え、`service_role`を唯一の管理者modelにしません。
    5.  **Performance Monitoring**: tenant増加に伴うRLS性能を監視し、実queryから必要なindexとInitPlan等の最適化を選び、§3.0のevidence要件で検証します。

---

## 30. pg_graphql (GraphQL API) 戦略

### Rule 30.1: The GraphQL API Design Protocol
-   **Law**: Supabase内蔵の**pg_graphql**を活用し、GraphQLインターフェースが必要な場合はPostgREST APIと併用しなければなりません。GraphQL専用のバックエンドサーバーの構築を回避します。
-   **Action**:
    1.  **Auto-Generated Schema**: pg_graphqlはPostgreSQLスキーマから**GraphQLスキーマを自動生成**します。テーブル、ビュー、関数が自動的にGraphQLタイプとして公開されます（§28のスキーマ公開ルールが適用されます）。
    2.  **RLS Integration**: pg_graphql経由のクエリにも**RLSポリシーが自動適用**されます。PostgREST APIと同一のセキュリティモデルが維持されるため、追加のアクセス制御実装は不要です。
    3.  **Endpoint**: GraphQLエンドポイントは `/graphql/v1` で公開されます。Supabase JSクライアントからは以下のように使用します:
        ```typescript
        const { data } = await supabase
          .from('graphql')
          .select('*')
          .single();
        // または直接fetchでGraphQLクエリを送信
        const response = await fetch(`${SUPABASE_URL}/graphql/v1`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_ANON_KEY,
            'Authorization': `Bearer ${session.access_token}`,
          },
          body: JSON.stringify({ query: '{ postsCollection { edges { node { id title } } } }' }),
        });
        ```
    4.  **Naming Convention**: pg_graphqlは`{TableName}Collection`の命名規則でコレクション型を生成します。テーブル名はPascalCaseで自動変換されるため、PostgreSQLのスネークケースとの対応を理解してください。

### Rule 30.2: The REST vs GraphQL Decision Protocol
-   **Law**: REST API（PostgREST）とGraphQL API（pg_graphql）は**ユースケースに応じて正しく使い分け**なければなりません。
-   **Action**:
    1.  **PostgREST（REST）を選択する場合**:
        -   単一テーブルのCRUD操作
        -   シンプルなフィルタリングとページネーション
        -   Supabase JSクライアントの型安全なクエリビルダーが活用可能
        -   キャッシュが重要な場合（HTTPキャッシュヘッダーの直接制御が容易）
    2.  **pg_graphql（GraphQL）を選択する場合**:
        -   複数テーブルの**ネストされたデータ**を1リクエストで取得する場合
        -   クライアント側が**必要なフィールドのみ**を選択取得する場合（Over-fetching防止）
        -   フロントエンドがGraphQLクライアント（Relay, Apollo等）を使用している場合
    3.  **Query Depth Limiting**: GraphQLクエリの深度制限をサーバー側で設定してください。深すぎるネストクエリはN+1問題を引き起こし、データベースに過負荷をかけます。
    4.  **Mutation via RPC**: 複雑なミューテーション（複数テーブルの同時更新等）は、GraphQLのミューテーションよりも**PostgreSQL関数 + RPC呼び出し**を推奨します。トランザクション保証とパフォーマンスの両面で優れています。
    5.  **Both APIs Coexistence**: 同一プロジェクトでREST APIとGraphQL APIを**併用可能**です。モバイルアプリはRESTのシンプルさを、ダッシュボードUIはGraphQLの柔軟性を活用する、という使い分けが有効です。

---

## 31. Database Functions & Triggers戦略 (Database Functions & Triggers Strategy)

### Rule 31.1: The Function Security Protocol
-   **Law**: Database関数は**SECURITY INVOKER**をデフォルトとし、`SECURITY DEFINER`は必要最小限の用途に限定しなければなりません。`SECURITY DEFINER`使用時は`search_path`の明示的設定を義務付けます。
-   **Action**:
    1.  **SECURITY INVOKER（デフォルト・推奨）**: 関数は呼び出し元ユーザーの権限で実行されます。RLSポリシーが自動適用されるため、最も安全です。
    2.  **SECURITY DEFINER（必要時のみ）**: 関数作成者の権限で実行されるため、RLSをバイパスします。以下の場合にのみ使用してください:
        -   RLSポリシー内で他のRLS保護テーブルを参照する場合（再帰防止）
        -   Auth Trigger（`auth.users`へのINSERT後にプロフィール自動作成等）
        -   FDW外部テーブルのデータを公開APIに制限公開する場合（§27.2参照）
    3.  **search_path必須設定**: `SECURITY DEFINER`関数では必ず`SET search_path = ''`を設定してください。これにより、攻撃者が`search_path`を操作してオブジェクトを偽装するリスクを低減します。
        ```sql
        CREATE OR REPLACE FUNCTION public.get_user_profile(user_id UUID)
        RETURNS JSONB
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = ''  -- 必須: search_path固定
        AS $$
        BEGIN
          RETURN (SELECT row_to_json(p) FROM public.profiles p WHERE p.id = user_id);
        END;
        $$;
        ```
    4.  **EXECUTE権限管理**: `public`スキーマの全関数はデフォルトで`anon`/`authenticated`から実行可能です。内部専用関数は`REVOKE EXECUTE`で保護してください。
        ```sql
        REVOKE EXECUTE ON FUNCTION internal.admin_operation FROM anon, authenticated;
        ```
    5.  **Immutable / Stable / Volatile**: 関数の副作用レベルを正しく宣言してください。`IMMUTABLE`（副作用なし、同入力で同出力）→ `STABLE`（読み取りのみ）→ `VOLATILE`（書き込みあり）。PostgreSQLオプティマイザがこの宣言を利用してクエリを最適化します。

### Rule 31.2: The Trigger Design Protocol
-   **Law**: Database Triggerは**AFTER トリガーを優先**し、トリガー関数内でのネットワーク通信や重い処理を禁止します。
-   **Action**:
    1.  **BEFORE vs AFTER**:
        -   **BEFORE**: データ検証・正規化に使用（例: `updated_at`の自動更新、入力値のサニタイズ）
        -   **AFTER**: 副作用の実行に使用（例: 監査ログ書き込み、通知送信、関連テーブル更新）
    2.  **トリガー関数の軽量化**: トリガー関数内で外部API呼び出しやHTTP通信を**実行しないでください**。代わりに、`pg_net`で非同期通知するか、イベントをキューテーブルに挿入してEdge Functionsで処理してください。
    3.  **FOR EACH ROW vs FOR EACH STATEMENT**: 行レベルの処理には`FOR EACH ROW`、バッチ操作の後処理には`FOR EACH STATEMENT`を使用してください。
    4.  **冪等性**: トリガー関数は**冪等**に設計してください。同一イベントが複数回発火しても安全な結果を返す設計が必須です。
    5.  **バージョン管理**: トリガーの作成・変更は必ず**マイグレーションファイル**で管理してください（§7参照）。ダッシュボードからの手動作成を禁止します。
    6.  **デバッグ**: `RAISE NOTICE`でトリガー内のデバッグ情報をログに出力してください。ログはSupabase Dashboardの「Logs > Postgres」で確認可能です。

---

## 32. Log Drain & 外部Observability統合戦略 (Log Drain & External Observability Strategy)

### Rule 32.1: The Log Drain Configuration Protocol
-   **Law**: service SLO、security detection、audit、incident responseに必要なlog／metric／traceを、必要期間query・相関・exportできるobservability pathへ送ります。provider内保持で要件を満たせない、集中SOC／SIEMが必要、または契約上の保持がある場合にLog Drain等の外部転送を採用します。
-   **Action**:
    1.  **Capability Check**: destination、plan availability、delivery guarantee、retry、ordering、latency、volume limit、egress costをdeploy時の公式文書で確認します。DatadogやHTTP endpointは候補であり固定要件ではありません。
    2.  **Retention & Access**: data class、investigation window、法令、costから保持期間をBlueprintで定め、暗号化、least privilege、tenant分離、deletion、legal holdを適用します。
    3.  **Structured Logging**: runtime／logging SDKが対応する構造化field、severity、trace correlation、source revisionを使用します。特定の`console.log(JSON.stringify(...))`形式へ固定しません。
    4.  **Sensitive Data Filtering**: sourceでPII、credential、token、request bodyをallowlist／redactionし、転送前後のsample testと権限testを行います。転送用Edge Functionを一律中継点にしません。
    5.  **Failure & Cost**: drain failure、duplicate、backpressure、provider outage、quota超過時の検知・buffer・drop policyとcost ownerを定義します。
    6.  **Control-Plane API Lifecycle**: log query、analytics、audit exportをManagement API等で自動化する場合はendpoint／API version、response schema、pagination、auth scope、rate／cost limit、deprecation deadline、consumer ownerを台帳化し、contract fixtureとshadow comparisonまたは同等手段で移行します。2026-07-23時点では`logs.all`から`logs`への移行を2026-09-23の削除前に完了し、結果件数、時刻範囲、filter、permission、failure alertのparityを検証します。Dashboardで閲覧できることをautomationの互換性証明にしません。

### Rule 32.2: The External Metrics & Alerting Protocol
-   **Law**: provider内外を問わず、user-visible SLI、capacity、database health、auth abuse、queue／function failureを検知できるmetricとalertを構成します。外部監視は複数systemの相関、保持、独立性、team運用に価値がある場合に採用します。
-   **Action**:
    1.  **Prometheus Metrics API**: Supabaseは`/metrics`エンドポイントでPrometheus互換メトリクスを公開します（Beta）。CPU使用率、I/O、WAL、接続数、クエリ統計をスクレイプ可能です。
    2.  **OpenTelemetry**: Supabaseは**OpenTelemetry（OTel）統合**をサポートしています。ログ・メトリクス・トレースをOTel互換ツール（Datadog, Honeycomb, Grafana等）にエクスポート可能です。
    3.  **Datadog Agent**: Datadogエージェントによる詳細なデータベースモニタリングが可能です。クエリメトリクス、サンプル、EXPLAINプランの可視化ができます。**エージェントはDedicated Poolerをバイパスしてホストに直接接続**してください。
    4.  **アラート設計**: thresholdはSLO、baseline、capacity headroom、provider quotaからBlueprintで決めます。以下は候補metricと参考開始点でありUniversal固定値ではありません:
        -   **接続数**: `active_connections / max_connections > 80%` → Warning
        -   **CPU使用率**: `> 90%` が5分以上持続 → Critical
        -   **ディスク使用率**: `> 80%` → Warning、`> 90%` → Critical
        -   **Auth失敗率**: 連続失敗 > 10回/分 → Brute-force検知アラート
        -   **Edge Functions エラー率**: `> 5%` → Warning
    5.  **§16との関係**: 本セクションは§16（内部Observability）を補完します。§16はSupabaseダッシュボード内の監視、§32は外部ツールとの統合に焦点を当てています。

---

## 33. Auth Hooks & Custom Claims戦略 (Auth Hooks & Custom Claims Strategy)

### Rule 33.1: The Custom Access Token Hook Protocol
-   **Law**: token claimを追加する場合はAuth Hook、IdP mapping、server-side authorization lookup等からfreshness、token size、revocation、latency、provider supportに合う方式を選びます。Auth Hookは発行時claim enrichmentの候補です。
-   **Action**:
    1.  **Hook Architecture**: Custom Access Token Hookは、トークン発行**直前**に実行されるPostgreSQL関数です。ユーザー情報を受け取り、カスタムクレームを含むJSONBを返却します。
        ```sql
        CREATE OR REPLACE FUNCTION public.custom_access_token_hook(event JSONB)
        RETURNS JSONB
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = ''
        AS $$
        DECLARE
          claims JSONB;
          user_role TEXT;
        BEGIN
          -- ユーザーのロールを取得
          SELECT role INTO user_role FROM public.user_roles
            WHERE user_id = (event->>'user_id')::UUID;
          -- クレームにロールを追加
          claims := event->'claims';
          claims := jsonb_set(claims, '{user_role}', to_jsonb(user_role));
          event := jsonb_set(event, '{claims}', claims);
          RETURN event;
        END;
        $$;
        ```
    2.  **Hook有効化**: ダッシュボード「Authentication > Hooks」で有効化してください。セルフホスト環境では環境変数で設定します:
        -   `GOTRUE_HOOK_CUSTOM_ACCESS_TOKEN_ENABLED=true`
        -   `GOTRUE_HOOK_CUSTOM_ACCESS_TOKEN_URI=pg-functions://<schema>/<function_name>`
    3.  **Reserved Claims**: Supabaseの予約クレーム（`iss`, `sub`, `aud`, `exp`, `iat`, `role`, `email`等）を**上書きしないでください**。カスタムクレームは`app_metadata`内またはカスタムキーとして追加してください。
    4.  **Performance**: Hook関数はトークン発行のたびに実行されます。**軽量に保ち**、重いクエリやネットワーク通信を含めないでください。

### Rule 33.2: The Auth Trigger Protocol
-   **Law**: auth event連動処理にはdatabase trigger、Auth Hook、webhook、queue／workflow等から、transaction coupling、failure isolation、retry、managed schema boundaryに合う方式を選びます。
-   **Action**:
    1.  **Profile Auto-Creation**: 新規ユーザー登録時にプロフィールテーブルを自動作成するトリガーパターン:
        ```sql
        CREATE OR REPLACE FUNCTION public.handle_new_user()
        RETURNS TRIGGER
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = ''
        AS $$
        BEGIN
          INSERT INTO public.profiles (id, full_name, avatar_url)
          VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'avatar_url');
          RETURN NEW;
        END;
        $$;
        CREATE TRIGGER on_auth_user_created
          AFTER INSERT ON auth.users
          FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
        ```
    2.  **Privilege Boundary**: managed auth schemaのtriggerを採用する場合はcurrent provider supportを確認し、必要最小owner／grant、safe search path、failure testを設けます。`SECURITY DEFINER`は必要性を証明した例外です。
    3.  **Error Handling**: トリガー関数内でエラーが発生すると、元の認証操作自体がロールバックされます。`BEGIN...EXCEPTION`ブロックでエラーを適切にハンドリングし、認証フロー全体の失敗を防止してください。
    4.  **Migration管理**: Auth Triggerの作成・変更は必ずマイグレーションファイルで管理してください（§7, §31.2参照）。

---

## 34. Self-hosted & Email Configuration戦略 (Self-hosted & Email Configuration Strategy)

### Rule 34.1: The Self-hosted Deployment Protocol
-   **Law**: self-host時はcurrent公式distribution、Kubernetes／container platform、Compose等からsupportability、HA、upgrade、backup、security、observabilityに適したtopologyを選び、managed serviceが担っていた全責任を明示的に所有します。
-   **Action**:
    1.  **Capacity Requirements**: component別CPU、memory、storage、IOPS、connection、replica、growthをload testとRPO／RTOからcapacity planningし、固定minimumをUniversalへ置きません。
    2.  **Critical Environment Variables**: 以下の環境変数を**必ず**デフォルト値から変更してください:
        -   `POSTGRES_PASSWORD`: 強力なパスワード
        -   `JWT_SECRET`: 最低32文字のランダム文字列
        -   `ANON_KEY` / `SERVICE_ROLE_KEY`: JWT_SECRETから生成されたキー
        -   `DASHBOARD_USERNAME` / `DASHBOARD_PASSWORD`: Supabase Studio認証
    3.  **Transport Security**: approved load balancer、gateway、reverse proxy等でcurrent TLS、certificate rotation、security header、trusted proxy chainを管理します。Caddy／Nginxは例です。
    4.  **Data Persistence**: Dockerボリュームでデータ永続化を設定してください。`docker-compose down`でデータが失われるデフォルト設定は本番不可です。
    5.  **Update Strategy**: Supabaseの各コンポーネント（GoTrue, PostgREST, Realtime等）のDockerイメージを定期的に更新してください。バージョン固定（`:latest`タグ禁止）を推奨します。
    6.  **Gateway Lifecycle**: API gateway、image、config、route、TLS termination、auth callback／SSO、header normalization、client IP、admin endpoint、plugin／custom policy、運用toolを1つの互換性単位としてinventory化します。default gateway変更前にcurrent公式distributionとの差分、positive／negative route test、canary、rollbackを検証します。KongやEnvoy等の製品名は時点依存の実装例であり、旧gateway overrideはownerと期限を持つ移行手段として扱います。

### Rule 34.2: The Email & SMTP Configuration Protocol
-   **Law**: production emailはvolume、deliverability、regional／privacy、bounce／complaint、SLA、costに適したproviderとbranded templateを使用します。組み込み送信が実効要件を満たす場合まで外部SMTPを一律強制しません。
-   **Action**:
    1.  **Effective Capability**: current built-in／custom SMTPのquota、deliverability、support条件を公式資料と実効設定から確認し、必要時に外部providerへ移行します。
    2.  **SMTP Configuration**: ダッシュボード「Authentication > SMTP Settings」または環境変数で設定:
        -   `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`
        -   `SMTP_SENDER_NAME`: 送信者表示名
        -   `SMTP_ADMIN_EMAIL`: 送信元メールアドレス
    3.  **Email Templates**: 以下のメールテンプレートを必ずカスタマイズしてください:
        -   サインアップ確認メール
        -   パスワードリセットメール
        -   招待メール
        -   メールアドレス変更確認メール
    4.  **Go Template Syntax**: テンプレートはGoテンプレート構文を使用します。`{{ .ConfirmationURL }}`, `{{ .Token }}`, `{{ .SiteURL }}`等の変数が利用可能です。
    5.  **Deliverability**: SPF, DKIM, DMARCレコードを送信ドメインに設定し、メールの到達率を最大化してください。設定不備はメールがスパムフォルダに分類される原因になります。

---

## 35. SSR & フレームワーク統合戦略 (SSR & Framework Integration Strategy)

### Rule 35.1: The @supabase/ssr Client Design Protocol
-   **Law**: SSR／server-rendered frameworkではcurrent公式adapterまたは同等実装でserver-readable session、secure cookie属性、refresh、request isolation、CSRF／XSS boundaryを満たします。`@supabase/ssr`は対応JavaScript frameworkの候補であり、全言語への要件ではありません。
-   **Action**:
    1.  **Browser Client**: クライアントコンポーネント用に`createBrowserClient`を使用してください。
        ```typescript
        // lib/supabase/client.ts
        import { createBrowserClient } from '@supabase/ssr';
        export function createClient() {
          return createBrowserClient(
            process.env.NEXT_PUBLIC_SUPABASE_URL!,
            process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
          );
        }
        ```
    2.  **Server Client**: Server Components / Server Actions / Route Handlers用に`createServerClient`を使用してください。Cookieの読み書きを`cookies()`経由で行います。
        ```typescript
        // lib/supabase/server.ts
        import { createServerClient } from '@supabase/ssr';
        import { cookies } from 'next/headers';
        export async function createClient() {
          const cookieStore = await cookies();
          return createServerClient(
            process.env.NEXT_PUBLIC_SUPABASE_URL!,
            process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
            { cookies: {
                getAll: () => cookieStore.getAll(),
                setAll: (cookiesToSet) => {
                  cookiesToSet.forEach(({ name, value, options }) =>
                    cookieStore.set(name, value, options));
                },
              },
            }
          );
        }
        ```
    3.  **Storage Boundary**: SSRでserverがsessionを必要とする場合はHttpOnly、Secure、SameSite等を設計したcookieまたはframework-supported server sessionを使います。client-only public token等はthreat modelを満たす別storageを選べます。
    4.  **@supabase/auth-helpers非推奨**: 旧パッケージ`@supabase/auth-helpers-nextjs`は非推奨です。`@supabase/ssr`に移行してください。

### Rule 35.2: The Middleware Auth Guard Protocol
-   **Law**: session refreshとearly route gatingはmiddleware、server hook、gateway等の候補です。ただしauthorizationはresource access boundaryで必ず再検証し、routing layerを唯一の防御線にしません。
-   **Action**:
    1.  **Session Refresh Middleware**: Middlewareで期限切れセッションをリフレッシュしてください。これにより、Server Componentsに到達する前にセッションが最新化されます。
        ```typescript
        // middleware.ts
        import { createServerClient } from '@supabase/ssr';
        import { NextResponse, type NextRequest } from 'next/server';
        export async function middleware(request: NextRequest) {
          let response = NextResponse.next({ request });
          const supabase = createServerClient(
            process.env.NEXT_PUBLIC_SUPABASE_URL!,
            process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
            { cookies: {
                getAll: () => request.cookies.getAll(),
                setAll: (cookiesToSet) => {
                  cookiesToSet.forEach(({ name, value, options }) => {
                    request.cookies.set(name, value);
                    response.cookies.set(name, value, options);
                  });
                },
              },
            }
          );
          const { data: { user } } = await supabase.auth.getUser();
          if (!user && request.nextUrl.pathname.startsWith('/dashboard')) {
            return NextResponse.redirect(new URL('/login', request.url));
          }
          return response;
        }
        ```
    2.  **Defense in Depth**: Middlewareはバイパス可能な脆弱性リスクがあります（CVE-2025-29927等）。**データアクセス層でも必ず`getUser()`で認証を検証**してください。Middlewareは最適化層として位置づけ、セキュリティの唯一の防御線にしないでください。
    3.  **Route Matcher**: `matcher`設定で静的アセット（`_next/static`, `favicon.ico`等）をMiddlewareから除外し、パフォーマンスを最適化してください。

---

## 36. Database Extensions管理戦略 (Database Extensions Management Strategy)

### Rule 36.1: The Extension Governance Protocol
-   **Law**: Database Extensionsは**必要最小限のみ有効化**し、有効化・無効化の操作は必ず**マイグレーションファイル**で管理しなければなりません。
-   **Action**:
    1.  **最小権限原則**: 不要な拡張を有効化しないでください。各拡張はDB接続時のメモリ消費やセキュリティ攻撃面を増加させます。
    2.  **Migration管理**: 拡張の有効化はマイグレーションで記録してください:
        ```sql
        -- マイグレーション: PostGIS有効化
        CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA extensions;
        -- マイグレーション: pg_trgm有効化（テキスト類似検索）
        CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA extensions;
        ```
    3.  **Schema Isolation**: 拡張は`extensions`スキーマに作成することを推奨します（Supabaseデフォルト）。`public`スキーマへの関数汚染を抑制します。
    4.  **推奨Extension一覧**:
        -   **pg_stat_statements**: クエリ統計（§36.2で詳述）— デフォルト有効
        -   **pgvector**: ベクトル類似検索（§17参照）
        -   **postgis**: 地理空間データ
        -   **pg_trgm**: トライグラムベースのテキスト検索・類似度計算
        -   **pg_net**: 非同期HTTP通信
        -   **pgjwt**: JWT生成・検証
        -   **uuid-ossp / pgcrypto**: UUID生成・暗号化

### Rule 36.2: The pg_stat_statements Performance Protocol
-   **Law**: **pg_stat_statements**を活用してクエリパフォーマンスを継続的に監視し、ボトルネックを特定・最適化しなければなりません。
-   **Action**:
    1.  **デフォルト有効**: Supabaseプロジェクトでは`pg_stat_statements`がデフォルトで有効化されています。
    2.  **スロークエリ検出**: 以下のクエリで最も実行時間の長いクエリを特定してください:
        ```sql
        SELECT query, calls, total_exec_time, mean_exec_time, rows
        FROM pg_stat_statements
        ORDER BY mean_exec_time DESC
        LIMIT 20;
        ```
    3.  **高頻度クエリ検出**: 実行回数が多いクエリも最適化対象です:
        ```sql
        SELECT query, calls, total_exec_time, rows
        FROM pg_stat_statements
        ORDER BY calls DESC
        LIMIT 20;
        ```
    4.  **統計リセット**: デプロイ後やスキーマ変更後は統計をリセットし、最新のパフォーマンスデータを取得してください:
        ```sql
        SELECT pg_stat_statements_reset();
        ```
    5.  **定期レビュー**: 週次または月次でスロークエリレポートを確認し、インデックス追加やクエリリライトの機会を特定してください。§4（Performance）と併用します。

---

## 37. Client SDK Best Practices戦略 (Client SDK Best Practices Strategy)

### Rule 37.1: The Error Handling & Retry Protocol
-   **Law**: 使用SDK／protocolのsuccess・error contractを明示的に処理し、retryはidempotentなtransient failureだけに限定します。`supabase-js`の`data`／`error`は一例です。
-   **Action**:
    1.  **構造化エラーハンドリング**: `supabase-js`のクエリは`data`と`error`を返します。常に`error`をチェックしてください:
        ```typescript
        const { data, error } = await supabase
          .from('profiles')
          .select('*')
          .eq('id', userId);
        if (error) {
          console.error('Query failed:', error.message, error.code);
          // ユーザーに適切なエラーメッセージを表示
          throw new AppError('プロフィールの取得に失敗しました');
        }
        ```
    2.  **Auth特有エラー**: Auth操作では`AuthError`クラスのサブタイプ（`AuthApiError`, `AuthRetryableFetchError`等）を判別し、リトライ可能かどうかを判断してください。
    3.  **Edge Functions エラー**: `FunctionsHttpError`（関数がエラーを返した）、`FunctionsRelayError`（Supabaseとのネットワーク問題）、`FunctionsFetchError`（関数到達不能）を区別してください。
    4.  **リトライロジック**: error分類、operation idempotency、dependency SLO、business deadline、retry budgetからjitter付きbackoff、最大attempt、circuit breakingを設定し、固定3回をUniversalへ置きません。
    5.  **タイムアウト**: end-to-end latency budgetをDNS／connect／request／stream／downstreamへ配分し、abort／cancellationを伝播します。固定5秒を全APIへ適用しません。

### Rule 37.2: The Realtime Subscription Lifecycle Protocol
-   **Law**: Realtime subscriptionは所有するcomponent、view、process、socket、background stateの終了時にcleanupし、reconnect、deduplication、ordering、rate controlをcontract化します。
-   **Action**:
    1.  **Subscription Cleanup**: Reactの場合、`useEffect`のクリーンアップ関数でサブスクリプションを解除してください:
        ```typescript
        useEffect(() => {
          const channel = supabase
            .channel('messages')
            .on('postgres_changes',
              { event: 'INSERT', schema: 'public', table: 'messages' },
              (payload) => setMessages(prev => [...prev, payload.new])
            )
            .subscribe();
          return () => { supabase.removeChannel(channel); };
        }, []);
        ```
    2.  **REPLICA IDENTITY**: Realtimeで`UPDATE`/`DELETE`イベントの全カラムデータを受信するには、対象テーブルに`REPLICA IDENTITY FULL`を設定してください:
        ```sql
        ALTER TABLE public.messages REPLICA IDENTITY FULL;
        ```
    3.  **高頻度更新の制御**: throttle、debounce、sampling、aggregationの間隔をUX latency、loss tolerance、quota、device性能から測定して決めます。
    4.  **Channel Status監視**: `channel.on('system', ...)`でチャネルのステータスを監視し、接続状態のフィードバックをユーザーに提供してください。
    5.  **RLS適用**: Realtimeデータはチャネルレベルでもテーブルレベルでもアクセスポリシーを設けてください（§3, §14参照）。

### Rule 37.3: Client Library Support Surface Protocol
-   **Law**: 「Supabaseが言語をsupportする」を単一の真偽値にしません。REST、Realtime、Auth、Storage、Functions invocation等のcapability、browser／server／mobile／desktop等のtarget、公式／communityのsupport主体、maturity、feature parity、release／security responseを別々にinventory化します。
-   **Current Snapshot**: 2026-07-23時点の公式Client Libraries資料はJavaScript／TypeScript、Dart／Flutter、Swift、Pythonをofficial library、C#、Go、Kotlin、Ruby、GDScript、Elixir、Rをcommunity libraryとして区分しています。これは将来の保証ではなく、採用時とmajor upgrade時に公式一覧、repository activity、release note、対応capabilityを再確認します。
-   **Adoption Evidence**: 採用clientごとにsession／credential storage、SSR／mobile lifecycle、type mapping、Realtime reconnect、upload、error／retry、offline behavior、supported platform、EOL、test matrixを記録します。公式clientでも全capabilityの同一feature parityを仮定せず、community clientにはaccountable owner、upstream continuity、direct protocol／generated client／service boundary等のfallbackを追加します。
-   **Language-Native Gates**: TypeScript／JavaScript、Swift、Kotlin、Dart、Pythonその他のcodeは `engineering/320_programming_language_governance.md` と各言語正本のnative gateを継承します。Client libraryの存在をEdge Functionsの実行runtime supportと解釈せず、Deno互換TypeScript／JavaScript runtime、PostgreSQL／SQL、client SDKを別surfaceとして検証します。

---

## 38. Schema Design Patterns戦略 (Schema Design Patterns Strategy)

### Rule 38.1: The Soft Delete & Data Lifecycle Protocol
-   **Law**: data categoryごとにhard delete、soft delete、tombstone、anonymization、legal holdを選びます。Soft Deleteはrestoreやauditが必要な候補ですが、privacy上の削除義務を代替せず、全dataへの一律要件ではありません。
-   **Action**:
    1.  **Deletion Representation**: soft deleteを選んだdata categoryでは、`deleted_at`等の明示的marker、actor、reason、restore権限、uniqueness、cascade、retentionをcontract化します。hard deleteを選んだdataまでmarkerを強制しません。
    2.  **Active Records Boundary**: soft deleteを選んだ場合、active dataだけを返すquery、View、repository等を1つの正本として設計します。次はViewの例です:
        ```sql
        CREATE VIEW public.active_profiles AS
          SELECT * FROM public.profiles WHERE deleted_at IS NULL;
        ```
    3.  **Authorization Alignment**: soft-deleted recordの通常参照をpolicyで拒否し、restore、audit、legal hold用の権限を分離します。次はRLSの例です:
        ```sql
        CREATE POLICY "Hide soft-deleted rows" ON profiles
          FOR SELECT USING (deleted_at IS NULL);
        ```
    4.  **Restore Contract**: 復元を提供する場合は権限、期間、uniqueness conflict、related data、auditを設計します。復元不能なcategoryにUIを強制しません。
    5.  **Final Disposition**: retention、legal hold、privacy deletion、backup expiryに従い、scheduler、queue、lifecycle job等でanonymizeまたは物理削除します。固定日数や`pg_cron`をUniversal要件にしません。

### Rule 38.2: The Audit Trail & JSONB Design Protocol
-   **Law**: データ変更履歴は**Audit Trail（監査証跡）**で追跡し、柔軟なメタデータには**JSONB**を適切に使用しなければなりません。
-   **Action**:
    1.  **Audit Mechanism Selection**: `supa_audit`、custom trigger、application event、logical decoding、provider log等から、required actor／before-after data、tamper resistance、throughput、retention、queryabilityに合う方式を選びます。固定ops閾値で監査を無効化せず、load testとcompliance要件からsampling、非同期化、別sinkを設計します。
    2.  **カスタムAudit Trail**: `supa_audit`で不足する場合は、トリガーベースのカスタム監査テーブルを作成してください:
        ```sql
        CREATE TABLE public.audit_log (
          id BIGSERIAL PRIMARY KEY,
          table_name TEXT NOT NULL,
          record_id UUID NOT NULL,
          action TEXT NOT NULL CHECK (action IN ('INSERT','UPDATE','DELETE')),
          old_data JSONB,
          new_data JSONB,
          changed_by UUID REFERENCES auth.users(id),
          changed_at TIMESTAMPTZ DEFAULT NOW()
        );
        ```
    3.  **JSONB使用基準**: JSONBは以下の場合に使用してください:
        -   スキーマが可変のメタデータ（Webhookペイロード等）
        -   頻繁なスキーマ変更が予想されるフィールド
        -   **NOT recommended**: 頻繁にクエリ・フィルタされるデータ → 正規化カラムを使用
    4.  **JSONBインデックス**: JSONBカラムにはGINインデックスを設定してください:
        ```sql
        -- 包含クエリ(@>)用
        CREATE INDEX idx_metadata ON products USING GIN (metadata jsonb_path_ops);
        -- 頻繁にアクセスするキー用
        CREATE INDEX idx_metadata_status ON products ((metadata->>'status'));
        ```
    5.  **pg_jsonschema**: `pg_jsonschema`拡張でJSONBデータのバリデーションを実装してください。データ整合性を高めます。

---

## 39. Social Auth & OAuthプロバイダ戦略 (Social Auth & OAuth Provider Strategy)

### Rule 39.1: The OAuth Provider Configuration Protocol
-   **Law**: Google/Apple/GitHub等のソーシャルログインを導入する場合は、**プロバイダ固有のベストプラクティス**に従い、Callback URLとクライアントシークレットを安全に管理しなければなりません。
-   **Action**:
    1.  **Callback URL標準形式**: 各プロバイダのOAuthアプリに設定するCallback URLは`https://<project-ref>.supabase.co/auth/v1/callback`です。
    2.  **Google OAuth**: Google Cloud Consoleで「OAuth同意画面」を設定し、Web用・iOS用・Android用のClient IDを個別に発行してください。`signInWithOAuth({ provider: 'google' })`で呼び出します。
    3.  **Apple Sign In**: Apple Developer Portalで「Sign In with Apple」のService IDとKeyを発行してください。**Apple審査要件**: アプリにAppleサインインを提供する場合は必ず目立つ位置に配置（HIG準拠）。
    4.  **GitHub OAuth**: GitHubのDeveloper Settingsで「OAuth App」を作成し、Client IDとClient Secretを取得してください。
    5.  **シークレット管理**: Client SecretはSupabaseダッシュボードのProvider設定にのみ格納し、**コードにハードコードしない**。環境変数にも格納しない（Supabase側で管理される）。
    6.  **スコープ最小化**: 各プロバイダで要求するスコープ（権限）は必要最小限にしてください。過剰なスコープはユーザーの信頼を損ないます。

### Rule 39.2: The SAML SSO & Mobile Deep Linking Protocol
-   **Law**: enterprise SSOはcurrent provider control plane、API、CLI、IaC等の承認経路で再現・監査可能に設定し、mobile redirectはverified Universal Links／App Links等の安全なcallbackを優先します。
-   **Action**:
    1.  **SAML SSO設定**: SAML 2.0はTeam/Enterpriseプランで利用可能です。CLI v1.46.4以上で設定してください:
        ```bash
        # IdPメタデータURLでSSO接続追加
        supabase sso add --type saml \
          --metadata-url "https://idp.example.com/metadata" \
          --domains "example.com"
        ```
    2.  **SAML有効化**: ダッシュボードのAuth Providers画面でSAML 2.0を有効化してください（デフォルトは無効）。
    3.  **ドメイン紐付け**: 複数のメールドメインをSSOプロバイダに紐付け可能です。自動参加（auto-join）とデフォルトロールを設定してください。
    4.  **Mobile Deep Linking**: モバイルアプリでは、メール確認・パスワードリセット・OAuthリダイレクト用にDeep Linkを設定してください:
        ```typescript
        // React Native / Expo
        const { data, error } = await supabase.auth.signInWithOAuth({
          provider: 'google',
          options: { redirectTo: 'com.myapp://auth/callback' }
        });
        ```
    5.  **Redirect URL登録**: SupabaseダッシュボードのAuth設定で、アプリスキーム（`com.myapp://**`）をRedirect URLsに登録してください。ワイルドカード使用可能。
    6.  **Universal Links（推奨）**: iOSではUniversal Links（`.well-known/apple-app-site-association`）、AndroidではApp Links（`assetlinks.json`）の設定を推奨します。Custom URL Schemeよりセキュリティが高いです。

---

## 40. Data Migration & Seeding戦略 (Data Migration & Seeding Strategy)

### Rule 40.1: The Database Migration Protocol
-   **Law**: 既存データベースからSupabaseへの移行手段は、source／target engine、data volume、許容停止時間、変更頻度、整合性、暗号化、rollback要件から選定し、手順をdocument化・再現可能にしなければなりません。`pg_dump`／`pg_restore`は互換PostgreSQL間の有力な選択肢ですが、全移行への一律要件ではありません。
-   **Action**:
    1.  **Discovery and Plan**: extension、type、constraint、trigger、function、role、grant、RLS、identity、large object、sequence、外部連携をinventory化し、mapping、cutover、rollback、data validation、ownerを定義します。
    2.  **Compatible PostgreSQL Example**: 互換性を確認できたPostgreSQL間では、`supabase db dump`または`pg_dump`／`pg_restore`を候補にできます:
        ```bash
        # スキーマのみ
        pg_dump --schema-only --no-owner --no-privileges \
          -d "postgresql://user:pass@host:5432/db" > schema.sql
        # データのみ
        pg_dump --data-only --no-owner \
          -d "postgresql://user:pass@host:5432/db" > data.sql
        ```
    3.  **Heterogeneous or Online Migration**: 異種engine、低停止時間、継続更新、大容量の場合は、検証済みETL、CDC、logical replication、bulk loader、段階的dual-runを比較します。toolやsize thresholdはbenchmarkとBlueprintで決めます。
    4.  **Security Reconciliation**: dump対象と復元挙動はoptionとversionで異なります。role、grant、RLS、Auth identity、secret、ownership、extensionを別inventoryで照合し、default denyを維持します。
    5.  **Validation and Cutover**: row countだけでなく、checksum／sample、constraint、sequence、permission、application contract、performance、RPO／RTO、rollback rehearsalをapproval evidenceに残します。

### Rule 40.2: The Seed Data Management Protocol
-   **Law**: initial／reference／test dataはschema migrationと責務を分離し、version管理されたapproved seed artifact、factory、snapshot等で再現可能にします。`supabase/seed.sql`はCLI既定候補です。
-   **Action**:
    1.  **Seed Discovery**: current CLI configurationの`seed_paths`または同等manifestでseed順序、environment eligibility、checksumを明示し、固定pathをUniversal要件にしません。
    2.  **スキーマ分離**: seed.sqlには**データINSERTのみ**を記述してください。テーブル定義やALTER文はマイグレーションファイル（§7参照）に配置します。
    3.  **モジュール化**: 大規模なシードデータは複数ファイルに分割し、`config.toml`で設定してください:
        ```toml
        [db]
        seed_paths = ["./supabase/seeds/users.sql", "./supabase/seeds/products.sql"]
        ```
    4.  **冪等性**: シードデータは`INSERT ... ON CONFLICT DO NOTHING`で冪等に記述してください。複数回実行してもエラーにならないようにします。
    5.  **環境別シード**: 開発用のダミーデータと本番用の初期マスタデータを分離し、環境変数やスクリプトで切り替えてください。本番シードは監査対象です。

---

## 41. Multigres & 水平スケーリング戦略 (Multigres & Horizontal Scaling Strategy)

### Rule 41.1: The Multigres Architecture Protocol
-   **Law**: 単一PostgreSQLのcapacity限界が測定された場合、partitioning、read replica、workload separation、distributed PostgreSQL／sharding等を比較します。Multigres等のemerging optionはcurrent maturity、support、migration、consistency、exitを検証してから採用します。
-   **Action**:
    1.  **Current Capability Evidence**: connection management、HA、failover、sharding等の提供段階、preview／GA、plan、region、support、制約を採用時点の公式資料と実証で確認し、roadmapを保証として扱いません。
    2.  **Shard Key Design**: query／transaction locality、cardinality、growth、hotspot、residency、rebalancing、cross-shard costからshard keyを選びます。tenant IDやuser IDは候補であり、random UUIDを含む任意の型を名前だけで排除しません。
    3.  **Application Compatibility**: driver、Data API、SDK、transaction、sequence、extension、migration、observability、backupの互換性をtestします。application transparencyや既存code無変更を前提にしません。
    4.  **Co-location Contract**: 同じtransactionや高頻度joinが必要なdataを測定に基づきco-locateします。全parent-childや全tenant dataを無条件に同一shardへ固定しません。
-   **Anti-pattern**: 単一テーブルが10億行を超えてから初めてシャーディングを検討する。§2.13（Time-Series Partitioning）で対処可能な段階で過剰なシャーディングに移行しない。
-   **Rationale**: Multigresは「Vitess for Postgres」として設計され、YouTubeをスケールさせたシャーディング技術をPostgreSQLに適用します。ただし、大多数のアプリケーションではパーティショニング（§2.13）とRead Replicas（§49）で十分であり、Multigresは真にグローバル規模のデータを扱う場合のみ検討してください。

### Rule 41.2: The OrioleDB Storage Engine Protocol
-   **Law**: Supabaseが提供する次世代ストレージエンジン**OrioleDB**の特性を理解し、ワークロードに応じた採用判断を行わなければなりません。
-   **Action**:
    1.  **Table AM Selection**: OrioleDBはPostgreSQLのTable Access Method（AM）として動作します。テーブル作成時に`USING orioledb`を指定することで、個別テーブル単位で採用可能です。
    2.  **Write-Heavy Optimization**: OrioleDBはundo log方式を採用し、高頻度の書き込みワークロードでVACUUM不要のパフォーマンスを提供します。書き込みが多いテーブル（ログ、イベント、キュー等）での採用を検討してください。
    3.  **Maturity Assessment**: OrioleDBは発展途上の技術です。本番環境での採用前に互換性テスト（拡張機能、RLS、トリガー等）を徹底し、フォールバック計画を準備してください。
-   **Rationale**: 従来のPostgreSQLのMVCC方式はテーブル膨張（Bloat）の原因となります。OrioleDBはこの根本的な課題を解決しますが、エコシステムの成熟度を慎重に評価する必要があります。

---

## 42. PostgreSQL 18新機能戦略 (PostgreSQL 18 New Features Strategy)

### Rule 42.1: The Asynchronous I/O (AIO) Optimization Protocol
-   **Law**: 実効database version、provider support、OS、設定が対応する場合にPostgreSQL 18のAIOを候補とし、代表workloadで有効性と回帰を測定して採用します。
-   **Action**:
    1.  **Capability Check**: current PostgreSQL、Supabase plan／region、I/O method、OS kernel、parameter、rollbackを公式資料と実効設定で確認します。managed環境で自動有効とは仮定しません。
    2.  **Benchmark**: sequential scan、VACUUM、concurrent OLTP等の代表workloadでthroughput、p95／p99 latency、CPU、I/O wait、costをbaselineと比較し、公開benchmarkの倍率を保証値にしません。
    3.  **Monitoring**: 利用可能な`pg_stat_io`等のtelemetryとprovider metricsで効果と飽和を観測し、upgrade／configuration evidenceを保存します。

### Rule 42.2: The UUIDv7 Migration Protocol
-   **Law**: identifierはordering、hotspot、privacy、offline generation、interoperability、index locality、runtime supportから選びます。PostgreSQL 18でUUIDv7は有力候補ですが、新規tableへの一律要件ではありません。
-   **Action**:
    1.  **UUIDv7 Candidate**: 時系列localityとdistributed generationが要件に合い、実効versionが対応する場合は`uuidv7()`を評価します。次は例です:
        ```sql
        CREATE TABLE public.new_table (
          id UUID PRIMARY KEY DEFAULT uuidv7(),
          created_at TIMESTAMPTZ DEFAULT NOW()
        );
        ```
    2.  **Trade-off Measurement**: insert locality、index size、page split、write hotspot、identifier enumeration、clock behaviorをULID、UUIDv4、sequence、compound key等と比較します。
    3.  **Migration Strategy**: 既存identifierはFK、external contract、replication、rollbackへの影響を評価し、business valueが証明された場合だけ移行します。新旧併存とno-opも正当な選択です。
    4.  **Compatibility Verification**: PostgreSQLのUUID型互換だけでapplication、serializer、SDK、downstream、ordering semanticsの互換を断定せず、contract testを行います。
-   **Rationale**: 時系列UUIDはB-tree localityを改善し得ますが、workloadとthreat modelでtrade-offが変わります。型名ではなく測定とcontractで選定します。

### Rule 42.3: The B-tree Skip Scan Protocol
-   **Law**: PostgreSQL 18のB-tree Skip Scanはplannerが選択し得る候補として扱い、既存／追加indexの判断を実行計画と実測で行います。
-   **Action**:
    1.  **Planner Choice**: `(a, b)`に対する`WHERE b = ...`でも統計、NDV、cost、cache状態によりSkip Scan、別index、Seq Scan等が選ばれ得るため、自動採用を保証しません。
    2.  **Index Design Impact**: leading columnのNDV、主要predicate、sort、write amplification、storage、maintenanceを合わせてindex順序と追加indexを決めます。
    3.  **EXPLAIN Verification**: production-representativeなdataとparameterで`EXPLAIN (ANALYZE, BUFFERS)`等を比較し、plan shape、rows estimate、latency、I/Oをevidence化します。
-   **Rationale**: planner機能は選択肢を増やしますが、特定planを保証しません。不要indexの削減とregression防止を測定で両立します。

---

## 43. Column-Level Security戦略 (Column-Level Security Strategy)

### Rule 43.1: The Column-Level Privilege Protocol
-   **Law**: テーブル内の特定カラム（給与、個人番号、内部メモ等）に対して、RLS（行レベル）に加えて**Column-Level Privileges**（列レベル権限）を設定し、多層防御を実現しなければなりません。
-   **Action**:
    1.  **GRANT/REVOKE per Column**: 機密カラムへのアクセスをロール単位で制御してください:
        ```sql
        -- 全カラムのSELECTを一旦取り消し
        REVOKE SELECT ON public.employees FROM authenticated;
        -- 非機密カラムのみSELECTを許可
        GRANT SELECT (id, name, department, title) ON public.employees TO authenticated;
        -- 機密カラムは管理者ロールのみ
        GRANT SELECT (salary, ssn, internal_notes) ON public.employees TO admin_role;
        ```
    2.  **View-Based Alternative**: Column-Level Privilegesの管理が複雑な場合は、公開用と管理用の**Viewを分離**するアプローチを推奨します:
        ```sql
        -- 公開用View（機密カラム除外）
        CREATE VIEW api.employees_public AS
          SELECT id, name, department, title FROM public.employees;
        -- 管理用View（全カラム）
        CREATE VIEW admin.employees_full AS
          SELECT * FROM public.employees;
        ```
    3.  **Trigger-Based Protection**: 特定カラムの更新を制限する場合、`BEFORE UPDATE`トリガーで変更を検知・拒否してください:
        ```sql
        CREATE OR REPLACE FUNCTION prevent_salary_update()
        RETURNS TRIGGER AS $$
        BEGIN
          IF OLD.salary IS DISTINCT FROM NEW.salary
             AND NOT (SELECT public.is_admin()) THEN
            RAISE EXCEPTION 'Salary updates require admin privileges';
          END IF;
          RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;
        ```
    4.  **RLS Complementarity**: Column-Level SecurityはRLSの**補完**であり、代替ではありません。RLS（どの行にアクセスできるか）+ CLS（どの列にアクセスできるか）の組み合わせで完全なデータ保護を実現してください。
-   **Rationale**: RLSだけでは「アクセス可能な行の全カラム」が公開されます。給与データや個人番号など、同一テーブル内でも感度レベルが異なるカラムが存在する場合、Column-Level Securityにより列単位の精密なアクセス制御が可能になります。

---

## 44. Passkeys & Biometric Auth戦略 (Passkeys & Biometric Authentication Strategy)

### Rule 44.1: The WebAuthn / Passkeys Integration Protocol
-   **Law**: パスワードレス認証として**Passkeys（WebAuthn/FIDO2）**を実装する場合は、Supabase Authとの統合パターンを遵守し、フィッシング耐性のある認証フローを構築しなければなりません。
-   **Action**:
    1.  **Integration Options**: Supabase環境でのPasskeys実装は以下の方式から選択してください:
        -   **1Password Passkey Flex**: SupabaseのRLSと統合された1Passwordのパスキーソリューション。公開鍵暗号とデバイスバイオメトリクスを活用。
        -   **Corbado / Descope**: サードパーティPasskeysプロバイダとSupabase Authの連携。Face ID、Touch ID、Windows Hello対応。
        -   **Custom WebAuthn**: `@simplewebauthn/server`等のライブラリを使用したカスタム実装。Edge Functionsでチャレンジ生成・検証を実装。
    2.  **Credential Storage**: Passkeysの公開鍵は専用テーブルに保存し、`auth.users`との外部キー関連を設定してください:
        ```sql
        CREATE TABLE public.passkey_credentials (
          id UUID PRIMARY KEY DEFAULT uuidv7(),
          user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
          credential_id TEXT NOT NULL UNIQUE,
          public_key BYTEA NOT NULL,
          counter BIGINT DEFAULT 0,
          device_type TEXT,
          created_at TIMESTAMPTZ DEFAULT NOW()
        );
        ALTER TABLE public.passkey_credentials ENABLE ROW LEVEL SECURITY;
        ```
    3.  **Fallback Auth**: Passkeysをサポートしないデバイス・ブラウザのために、従来のEmail/Password認証を**フォールバック**として維持してください。Passkeysのみの認証は現時点では推奨しません。
    4.  **MFA Complementarity**: Passkeysは単独で強力な認証ですが、高セキュリティ要件では`aal2`レベルのMFA（§18.2参照）と組み合わせることを推奨します。
-   **Rationale**: Passkeysはフィッシング耐性があり、パスワード漏洩リスクを大幅に低減します。2025年以降、主要ブラウザとOS全てがPasskeysをサポートしており、パスワードレス認証の標準として採用が進んでいます。

---

## 45. MCP Server & AI開発統合戦略 (MCP Server & AI Development Integration Strategy)

### Rule 45.1: The Supabase MCP Server Protocol
-   **Law**: Supabase MCPを採用する場合は、通常のproduction accessと分離したleast-privilegeの開発支援境界として扱います。MCP導入自体は必須ではなく、導入価値がaccess拡大、data exposure、prompt injection、誤操作、audit負荷を上回ることをBlueprintで判断します。
-   **Action**:
    1.  **Current Capability Check**: remote／localの提供状況、authentication、tool scope、read-only option、project scopeをcurrent official documentationで再確認し、環境とthreat modelに合う方式を選びます。
    2.  **Permitted Operations**: MCP経由でAIが実行可能な操作:
        -   テーブル設計・スキーマ管理
        -   データクエリ（読み取り）
        -   マイグレーション生成の補助
        -   Edge Functions のスキャフォールディング
    3.  **Prohibited Operations**: MCP経由での以下の操作はAIに委任**禁止**:
        -   本番データの直接変更（INSERT/UPDATE/DELETE）
        -   RLSポリシーの自動適用（レビューなし）
        -   Service Roleキーの使用
        -   バックアップ・リストア操作
    4.  **Project-scoped Access**: MCP接続にはProject-scoped Roles（§51参照）を使用し、AIツールのアクセス範囲を最小権限に制限してください。
    5.  **Audit Trail**: MCP経由の全操作を監査ログに記録し、AIが生成・実行したSQLを追跡可能にしてください。
-   **Rationale**: AIコーディングアシスタントはスキーマ設計やクエリ最適化の生産性を劇的に向上させますが、本番データへの書き込み権限を与えるとデータ破壊リスクが生じます。Read-onlyアクセスを基本とし、書き込みは人間のレビューを経由させてください。

---

## 46. Security Advisor & 自動修復戦略 (Security Advisor & Auto-Remediation Strategy)

### Rule 46.1: The Security Advisor Compliance Protocol
-   **Law**: Supabase **Security Advisor**の所見は§0.1のrisk-based gateでトリアージし、未解決の適用可能なCritical／Highまたは説明不能な所見をreleaseへ持ち込まない。
-   **Action**:
    1.  **Risk-Based Scan**: schema、policy、extension、privilege変更時と、Blueprintで定義したrisk-based cadenceで実行し、可能ならCIまたはrelease evidenceへ統合する。
    2.  **Disposition**: severity、reachability、data sensitivity、exploitability、false positive、owner、期限、compensating controlで優先度を決める。固定SLAはBlueprintへ置く。
    3.  **AI-Assisted Fix**: Security AdvisorのAI修正提案は参考として活用してください。ただし、提案されたSQLを**無検証で適用することは禁止**です。必ずRLSの影響範囲を確認してから適用してください。
    4.  **Baseline Maintenance**: 所見数だけでなく、各所見の状態、根拠、owner、期限をbaselineとして追跡し、件数減少だけで安全を断定しない。
-   **Rationale**: Security Advisorは2025年のSupabaseアップデートで大幅に強化され、AI支援による修正提案が追加されました。人間のレビューと組み合わせることで、セキュリティ品質を継続的に維持するための強力なツールとなります。

---

## 47. テーブル別API制御 & Data API無効化戦略 (Per-Table API Control & Data API Disable Strategy)

### Rule 47.1: The Granular API Exposure Protocol
-   **Law**: Data APIの公開面は、exposed schema、schema／table／function grant、RLS、column privilege、API設定を別統制としてdeny-by-defaultに設計する。新規tableの自動公開有無などのdefaultはversionやproject設定で変わるため、生成時に実効設定を検証する。
-   **Action**:
    1.  **Exposure Inventory**: exposed schemaとAPI到達可能なtable、view、functionをmachine-readableに棚卸しし、migration testで意図した対象だけが到達可能と検証する。
    2.  **Default Deny**: 新規objectは明示的なAPI contract、最小grant、RLS／column privilege、negative testが揃うまで公開しない。
    3.  **Data API Disable**: Data APIが不要なworkloadでは無効化を評価する。ただしmanagement、SDK、integrationへの影響とrollbackを確認する。
    4.  **API Layer Architecture**: direct Data API、Edge Functions、独自API gateway等を、認可、validation、latency、cost、portabilityで比較する。次は参考patternである:
        ```
        Client → Approved API Layer（認証・認可・validation）→ Supabase DB
        ```
-   **Rationale**: PostgREST Data APIは開発の高速化に貢献しますが、全テーブルをAPI公開すると攻撃面が不必要に拡大します。テーブル別の制御により、必要最小限のAPI公開を実現し、§28の原則をより簡便に適用できます。

---

## 48. VPC & Private Link戦略 (VPC & Private Link Strategy)

### Rule 48.1: The Network Isolation Protocol
-   **Law**: data sensitivityとthreat modelに応じてprivate connectivity、network restriction、TLS、identity-aware accessを組み合わせ、public exposureを必要最小限にする。
-   **Action**:
    1.  **Private Connectivity**: 利用plan、region、network topologyが対応する場合、PrivateLink等を候補として評価する。private pathでも認証、暗号、DNS、egress、provider control planeのriskは残る。
    2.  **Network Restriction**: static egress、VPN、private connectivity等で安定したsource identityを証明できる場合にIP／CIDR制限を適用します。dynamic CIを広域allowlistへ入れず、federated identity、ephemeral runner、proxy等を評価します。
    3.  **TLS Enforcement**: database connectionはproviderまたはself-hosted topologyの現行TLS contractを確認し、証明書検証を含む暗号化を強制します。private networkだけを平文通信の根拠にしません。
    4.  **Privileged Human Access**: production DBへの人間accessは通常pathから分離し、MFA、time-bound identity、approval、session audit、least privilege、revocationを備えます。identity-aware proxy、provider access、bastion、temporary tokenは候補であり、永続SSH踏み台を一律要求しません。
    5.  **Zero Trust**: ネットワーク分離はセキュリティレイヤーの1つに過ぎません。RLS（§3）、Column-Level Security（§43）、Data API Hardening（§28）と組み合わせた多層防御を維持してください。
-   **Rationale**: ネットワークレベルの分離は、アプリケーションレベルのセキュリティ（RLS等）とは独立した防御層です。万が一RLSに設定漏れがあっても、ネットワーク分離により外部からの攻撃を物理的に遮断できます。

---

## 49. Read Replicas & 負荷分散戦略 (Read Replicas & Load Balancing Strategy)

### Rule 49.1: The Read Replica Architecture Protocol
-   **Law**: Read Replicaは、計測されたread bottleneck、latency、availability、analytics isolation、regional requirementを満たす候補として評価し、必要性と費用対効果が確認できた場合に採用します。
-   **Action**:
    1.  **Query Routing**: providerやpoolerが自動routingすると思い込まず、current plan／endpointの挙動を確認します。write、strong read-after-write、transactional readはprimaryへ、stale-tolerant readだけを明示的にreplicaへ送る設計を基本とします。
    2.  **Replication Lag Awareness**: 非同期replicationのlagとfailure modeを計測し、整合性要件に応じてread-your-writes、session stickiness、primary fallback、staleness表示を設計します。
    3.  **Regional Placement**: latency、data residency、failure domain、cross-region transfer cost、service availabilityを合わせて配置を決めます。
    4.  **Analytics Offloading**: analyticsのisolation効果を負荷試験で確認し、replicaがOLTP影響を完全にゼロにするとは仮定しません。
    5.  **Monitoring**: replication lag、replay failure、connection saturation、primary／replica error、fallbackを監視し、alert thresholdはSLOとdata consistency budgetからBlueprintで定義します。
-   **Rationale**: 単一のプライマリDBに全ての読み書きを集中させると、CPU/メモリの飽和によりレスポンスタイムが劣化します。Read Replicaにより読み取り性能を水平スケールし、プライマリの書き込み性能を保護します。

---

## 50. Project-scoped Roles & チーム管理戦略 (Project-scoped Roles & Team Management Strategy)

### Rule 50.1: The Project-scoped RBAC Protocol
-   **Law**: 現行planと実効role capabilityを確認し、人間、workload、CI、AI toolの権限をorganization／project／environment／feature group単位で最小化します。role名だけを安全性の根拠にしてはなりません。
-   **Action**:
    1.  **Capability Inventory**: Owner、Administrator、Developer、Read-Only等の名称を現行access-control文書へ照合し、project-scoped roleのplan availabilityと、secret閲覧を含む実効permissionを記録します。`Read-Only`をsecretlessや無害と仮定しません。
    2.  **Human Access**: job functionで必要なfeature groupだけを付与し、production write／secret／billing／member管理はstep-up、承認、time-bound elevation、break-glassを適用します。全開発者への一律role付与は禁止します。
    3.  **Workload Identity**: CI/CDには個人credentialを使わず、environmentとjobを限定した専用identity、short-livedまたは失効可能なcredential、protected context、rotation、auditを用います。
    4.  **Lifecycle Review**: joiner／mover／leaver eventで即時更新し、inventory、usage telemetry、risk、complianceに応じたcadenceでunused／over-privileged accessをreviewします。
    5.  **AI/MCP Integration**: AI toolはread-onlyかつ明示project scopeを既定とし、利用feature group、data class、tool call、approval境界を限定します。write／DDL／production data accessはtask単位の人間承認と監査証跡なしに許可しません。
-   **Rationale**: 全メンバーにOwner権限を付与する「フラットアクセス」は、権限昇格攻撃や誤操作のリスクを最大化します。最小権限原則（PoLP）により、インシデント発生時の影響範囲を最小化します。

---

## 51. Provider-neutral CI/CD戦略 (Provider-neutral CI/CD Strategy)

### Rule 51.1: The Supabase CI/CD Pipeline Protocol
-   **Law**: 選定したCI/CD providerに依存せず、migration、policy test、function／configuration deploy、promotionをversion管理されたreproducible pipelineへ統合します。production mutationはprotected environment、separation of duties、明示承認、監査、concurrency controlを通します。
-   **Action**:
    1.  **Pipeline Contract**: clean rebuild → migration lint／reset → RLS／permission／data-contract test → artifact／type generation drift check → preview／staging apply → production approval → post-deploy verificationの順序とevidenceを定義します。
    2.  **Environment Strategy**: project、credential、dataをenvironmentごとに分離します。branch／preview環境はplan、cost、PII、test fidelity、lifecycleが適合する場合に採用し、全PRへの一律作成を強制しません。
    3.  **Schema Recovery**: destructive migrationの自動reverse rollbackを安全と仮定しません。expand-contract、backward-compatible application、backup／restore、forward-fix、deployment haltの手順をchange classごとに定義します。
    4.  **Credential Management**: CI providerの承認済みsecret storeまたはfederated／short-lived identityを使用し、repository、workflow、log、preview clientへprivileged keyを露出しません。
    5.  **Deployment Evidence**: source revision、migration checksums、artifact digest、approver、target project／environment、command／tool version、result、rollback／forward-fix decisionを保存し、ownerが利用する承認済みchannelへ通知します。
-   **Rationale**: 手動デプロイは「デプロイ忘れ」「環境差異」「手順ミス」の三重リスクを生みます。CI/CD自動化により、全環境で一貫したデプロイプロセスを保証し、人的エラーを構造的に低減します。

---

## 52. PostgreSQL Advisory Locks & 同時実行制御戦略 (PostgreSQL Advisory Locks & Concurrency Control Strategy)

### Rule 52.1: The Advisory Lock Architecture Protocol
-   **Law**: 排他、leader election、重複実行防止には、transaction row lock、unique constraint、lease、queue guarantee、idempotency key、advisory lock等から、failure modelとownershipに適合するcoordination mechanismを選びます。Advisory Lockはapplication-defined resourceが同一PostgreSQL境界に閉じる場合の候補です。
-   **Action**:
    1.  **Session vs Transaction Locks**: transaction lockを安全な既定候補とします。session lockはconnection poolのsession affinity、disconnect、timeout、cleanup、ownership transferを証明できる場合だけ使用し、長時間batchという理由だけで選びません。
    2.  **Acquisition Policy**: blocking／try lock、timeout、retry、skip、fencing tokenをbusiness semanticsに合わせ、無期限待機を禁止します。
    3.  **Lock Key Design**: key mappingはnamespace、collision、multi-tenant isolation、64-bit安定性を定義し、同じresourceが全callerで同じkeyへ写るtestを持ちます。次は非規範例です:
        ```sql
        SELECT pg_try_advisory_lock(
          'batch_jobs'::regclass::integer,
          hashtext('daily_report')
        );
        ```
    4.  **Deadlock Prevention**: 複数のAdvisory Lockを取得する場合は、常に同一の順序で取得してください。順序の不統一はデッドロックの原因です。
    5.  **Release & Failure**: session lockは明示unlockとfinally、connection loss、process crash、pool reuseをtestします。transaction lockはtransaction durationを短く保ち、external side effectをlock保持中へ安易に含めません。
-   **Rationale**: Coordination mechanismごとにscope、lease、fencing、failure recoveryが異なります。Advisory Lockの強制ではなく、重複副作用とstale ownerを防ぐ検証可能な設計を要求します。

---

## 53. Webhook Signature & イベント駆動統合戦略 (Webhook Signature & Event-Driven Integration Strategy)

### Rule 53.1: The Webhook Security Protocol
-   **Law**: webhookはproviderの認証contractに従う署名、mTLS、token、network control等で送信元とpayload integrityを検証し、replayと重複副作用を防ぎます。署名対応providerではraw bodyに対する署名検証を必須とします。
-   **Action**:
    1.  **Provider Verification Contract**: algorithm、header、canonicalization、key rotation、multiple signature、raw body要件はcurrent provider仕様に従い、timing-safe comparisonとnegative testを実装します。HMAC-SHA256は例であり固定しません:
        ```typescript
        const signature = req.headers.get('x-webhook-signature');
        const expectedSig = createHmac('sha256', WEBHOOK_SECRET)
          .update(body).digest('hex');
        if (signature !== expectedSig) {
          return new Response('Unauthorized', { status: 401 });
        }
        ```
    2.  **Replay Window**: provider timestamp、clock skew、delivery retry、business latencyからfreshness windowを定め、event ID、nonce、signature version等と組み合わせます。固定5分をUniversal要件にしません。
    3.  **Idempotency Key**: provider event IDまたは正規化した冪等性キーをatomic unique constraint等で記録し、同一eventの副作用をexactly-onceと誤認しないよう処理状態とretryを設計します。
    4.  **Failure Recovery**: delivery保証とbusiness criticalityに応じてdurable inbox、queue、DLQ、replay tool、alert、manual reconciliationを選び、受付と重い処理を分離します。
    5.  **Schema Evolution**: providerのevent type／API versionを検証し、unknown field tolerance、required field、adapter、contract fixture、deprecation migrationを設計します。受信側がprovider payloadへ任意のversionを追加できるとは仮定しません。
-   **Rationale**: 署名なしのWebhookは「誰でも偽リクエストを送信可能」な攻撃面です。署名検証により認証されたリクエストのみを処理しやすくし、データの整合性とセキュリティを高めます。

---

## 54. Database Partitioning高度戦略 (Advanced Database Partitioning Strategy)

### Rule 54.1: The Partitioning Decision Framework
-   **Law**: partitioningは固定record数ではなく、measured query／maintenance bottleneck、retention delete、tenant／region isolation、vacuum、index、backup、operational complexityを比較し、非partition tableではSLOを満たせない場合に採用します。
-   **Action**:
    1.  **Partition Type Selection**:

        | タイプ | キー例 | ユースケース |
        |:-------|:-------|:------------|
        | **Range** | `created_at` | ログ、トランザクション（月次分割） |
        | **List** | `tenant_id`, `region` | マルチテナント、地域分離 |
        | **Hash** | `user_id` | 均等分散が必要な大規模テーブル |

    2.  **Lifecycle Automation**: native automation、`pg_partman`、scheduled migration等から、provider supportと復旧手順に適合する方法を選びます。次は非規範例です:
        ```sql
        SELECT partman.create_parent(
          p_parent_table := 'public.audit_logs',
          p_control := 'created_at',
          p_type := 'range',
          p_interval := '1 month',
          p_premake := 3
        );
        ```
    3.  **Partition Pruning**: query semanticsが許す場合にpartition key predicateを含め、代表queryでpruningを`EXPLAIN`確認します。全期間集計等、keyを限定できない正当なqueryには別のaggregate、replica、analytics pathを設計します。
    4.  **Index Strategy**: partitionごとのindex、unique constraint制約、新partitionへの適用、attach／detach、restoreを実versionのPostgreSQLとautomation toolでtestします。
-   **Rationale**: 単一の巨大テーブルは、VACUUM時間の増大、インデックス再構築の長時間化、バックアップサイズの膨張を引き起こします。パーティショニングによりこれらの運用負荷を大幅に軽減します。

---

## 55. Full-Text Search & pg_trgm戦略 (Full-Text Search & pg_trgm Strategy)

### Rule 55.1: The PostgreSQL Native Search Protocol
-   **Law**: 全文検索には外部サービス（Algolia, Elasticsearch等）を安易に採用せず、まず**PostgreSQLネイティブの全文検索機能**（tsvector/tsquery）の適用を検討しなければなりません。
-   **Action**:
    1.  **tsvector Column**: 全文検索対象テーブルには`tsvector`型の生成カラムを追加し、GINインデックスを作成してください:
        ```sql
        ALTER TABLE public.articles ADD COLUMN search_vector tsvector
          GENERATED ALWAYS AS (
            setweight(to_tsvector('japanese', coalesce(title, '')), 'A') ||
            setweight(to_tsvector('japanese', coalesce(body, '')), 'B')
          ) STORED;
        CREATE INDEX idx_articles_search ON public.articles USING gin(search_vector);
        ```
    2.  **Weight System**: `setweight`で検索フィールドに重み付けを行い、タイトルマッチを本文マッチより優先してください（A > B > C > D）。
    3.  **Locale-Specific Language Support**: CJK言語（日本語・中国語・韓国語）の全文検索には`pgroonga`拡張（§36参照）を推奨します。例: PostgreSQL標準の`japanese`辞書は形態素解析の精度が限定的です。
    4.  **pg_trgm for Fuzzy Search**: 部分一致・あいまい検索には`pg_trgm`（トライグラム）拡張を使用し、`LIKE '%keyword%'`のパフォーマンスを大幅に向上させてください:
        ```sql
        CREATE EXTENSION IF NOT EXISTS pg_trgm;
        CREATE INDEX idx_articles_title_trgm ON public.articles
          USING gin(title gin_trgm_ops);
        ```
    5.  **Hybrid Approach**: `tsvector`（構造化全文検索）+ `pg_trgm`（あいまい検索）+ `pgvector`（セマンティック検索/§17参照）の組み合わせで、多層的な検索体験を構築してください。
-   **Rationale**: 外部検索サービスは追加コスト・データ同期・レイテンシの3つの負担を生みます。PostgreSQLネイティブの検索機能は、中規模までのアプリケーションでは十分な性能を発揮し、インフラの複雑性を大幅に削減します。

---

## 56. Supabase AI Assistant & 生成SQL戦略 (Supabase AI Assistant & Generated SQL Strategy)

### Rule 56.1: The AI-Generated SQL Governance Protocol
-   **Law**: SupabaseダッシュボードのAI Assistant（SQL生成機能）やMCP Server経由でAIが生成したSQLを、**無検証で本番環境に適用することを禁止**します。
-   **Action**:
    1.  **Review Mandate**: AI生成SQLは必ず以下の観点でレビューしてください:
        -   **RLS影響**: 生成されたDDLがRLSポリシーに影響を与えないか
        -   **パフォーマンス**: `EXPLAIN ANALYZE`で実行計画を確認
        -   **セキュリティ**: `SECURITY DEFINER`関数のsearch_path設定、権限昇格リスク
        -   **冪等性**: §12.2の冪等マイグレーション原則に準拠しているか
    2.  **Prompt Injection Defense**: AI SQL生成に使用するプロンプトには、ユーザー入力を直接含めないでください。プロンプトインジェクション攻撃により、意図しないDDL/DMLが生成されるリスクがあります。
    3.  **Sandbox Execution**: AI生成SQLはまずローカル環境（`supabase db reset`後のクリーンDB）で実行し、問題がないことを確認してから本番に適用してください。
    4.  **Audit**: AI生成SQLのソースを明示し（コメントに`-- AI-generated: [tool_name] [date]`）、将来のトラブルシューティングに備えてください。
-   **Rationale**: AIは構文的に正しいが意味的に危険なSQL（例: `USING (true)` の過剰適用）を生成する可能性があります。人間のレビューと段階的適用により、AIの生産性向上とセキュリティを両立させます。

---

## 57. 型安全エンドツーエンド戦略 (Type-Safe End-to-End Strategy)

### Rule 57.1: The Full-Stack Type Safety Protocol
-   **Law**: DB schemaからAPI、event、backend、clientまで、採用言語で検証可能なdata contract chainを構築します。compile-time typeがない境界はruntime schema、contract test、generated client等で補完します。
-   **Action**:
    1.  **Layer 1 — Schema Contract**: migration／database schemaを正本とし、採用言語向けの公式generator、schema introspection、OpenAPI等でclient contractを再現可能に生成します。TypeScript生成は一例です。
    2.  **Layer 2 — Runtime Validation**: untrusted API、event、database JSON等の境界は、Zod、JSON Schema、language-native validator等の承認済み手段で検証します。次は非規範例です:
        ```typescript
        import { z } from 'zod';
        const CreatePostSchema = z.object({
          title: z.string().min(1).max(200),
          body: z.string().min(10),
          status: z.enum(['draft', 'public']),
        });
        type CreatePostInput = z.infer<typeof CreatePostSchema>;
        ```
    3.  **Layer 3 — Domain Adapter**: persistence、domain、transport、view modelの境界で必要な変換を明示し、null、decimal、time、enum未知値、PIIをtestします。固定の三層名やMapped Typeを一律要求しません。
    4.  **Layer 4 — Type Synchronization**: CI/CDパイプライン（§51参照）に型生成ステップを組み込み、スキーマ変更時に型定義が更新・検証される状態を維持してください。
    5.  **Contract Gap Detection**: `tsc --noEmit`、compiler、type checker、schema compatibility test等、採用言語nativeのgateをCIへ組み込みます。詳細は`engineering/320_programming_language_governance.md`に従います。
-   **Rationale**: 型安全チェーンの途切れ（Any型の乱用、手動型定義のドリフト）は、ランタイムエラーの大きな原因です。DBからUIまでの型安全チェーンにより、コンパイル時に検出できるバグを増やします。

---

## 58. グローバルCDN & Edge Caching戦略 (Global CDN & Edge Caching Strategy)

### Rule 58.1: The Edge Caching Architecture Protocol
-   **Law**: cacheability、data classification、freshness、invalidation、personalization、version skew、costからpublic responseのcache policyを決めます。最大cache hit率ではなく、正しさと安全性を満たした上でorigin loadとlatencyを最適化します。
-   **Action**:
    1.  **Cache-Control Headers**: バケット・エンドポイントごとに適切な`Cache-Control`ヘッダーを設定してください:

        | コンテンツタイプ | 参考Cache-Control | Blueprintで決める条件 |
        |:---------------|:-------------|:----|
        | content-addressed静的asset | `public, immutable` | digest変更まで不変であること |
        | 公開画像 | `public, max-age=...` | 更新頻度とpurge能力 |
        | 公開API response | `s-maxage=..., stale-while-revalidate=...` | freshness SLOとstale許容 |
        | user-specific／sensitive data | `private`または`no-store` | shared cache keyへ混入しないこと |

    2.  **Stale-While-Revalidate**: 公開APIエンドポイントには`stale-while-revalidate`ディレクティブを活用し、キャッシュ更新中も古いデータを返すことでユーザー体験を維持してください。
    3.  **Cache Invalidation**: コンテンツ更新時はCDNのキャッシュを明示的にパージするか、URLにバージョンパラメータ（`?v=hash`）を付与してキャッシュバスティングを実行してください。
    4.  **Provider-neutral Integration**: 採用CDN／application platformとSupabase Storage／APIのcache key、auth header、cookie、purge、signed URL、version skewを統合testします。Cloudflareは候補の一つです。
-   **Rationale**: CDNキャッシュなしでは全リクエストがオリジンに到達し、Supabaseのコンピュート・ネットワーク使用量が不必要に増大します。適切なキャッシュ戦略により、コスト削減とレスポンス高速化を同時にもたらします。

---

## 59. コンプライアンス & データ主権戦略 (Compliance & Data Sovereignty Strategy)

### Rule 59.1: The Regulatory Compliance Framework
-   **Law**: 対象法域のdata protection法、業界規制、契約control、assurance frameworkを区別して特定し、Supabase利用時の責任分界と技術・運用controlを実装しなければなりません。SOC 2等のattestationを法令そのものとして扱いません。
-   **Action**:
    1.  **Data Classification**: 全dataを分類し、固定のsensitivity recipeへ依存せず、暗号化、retention、access、residency、deletion、auditをBlueprintで定義します。

    2.  **Region Selection**: PIIのlocationは、適用法、契約、cross-border transfer、subprocessor、backup／replica location、current provider region capabilityを法務・privacy ownerと確認します。region名だけで準拠を断定しません。
    3.  **DSAR Workflow**: 適用法の期限と本人確認、例外、legal hold、第三者data、export／deletion scopeをworkflow化します。RPCは実装候補の一つであり、固定の24時間SLAをUniversalに置きません。
    4.  **SOC2 Alignment**: Supabase自体がSOC2 Type II認証を取得しています。アプリケーション層でもSOC2の原則（暗号化、アクセス制御、監査ログ、インシデント対応）を実装してください。
    5.  **Cookie Consent**: SSRフレームワーク（§35参照）のCookie管理と連携し、ユーザーの同意なしにトラッキングCookieやAnalytics IDを設定しないでください。
-   **Rationale**: データ保護規制への非遵守は、罰金のリスクだけでなく、アプリストアからのリジェクト、ユーザー信頼の喪失を招きます。設計段階での組み込み（Privacy by Design）が最もコスト効率が高い遵守方法です。

---

## 60. Supabase運用成熟度モデル (Supabase Operational Maturity Model)

### Rule 60.1: The Maturity Assessment Protocol
-   **Law**: プロジェクトのSupabase運用成熟度を定期的に自己評価し、段階的に成熟度を向上させなければなりません。
-   **Maturity Levels**:

    | レベル | 名称 | 基準 |
    |:-------|:-----|:-----|
    | **L1: Reactive** | 場当たり | 手動マイグレーション、RLSなし、テストなし |
    | **L2: Managed** | 管理 | Migration Gitに管理、基本RLS、手動デプロイ |
    | **L3: Defined** | 定義 | CI/CD自動化、RLSテスト、Security Advisor遵守 |
    | **L4: Optimized** | 最適化 | Branching、Full Type Safety、FinOps、監視完備 |
    | **L5: Resilient** | 回復力 | DR計画テスト済、セキュリティ監査自動化、Incident Response整備 |

-   **Action**:
    1.  **Risk-based Assessment**: major release、incident、architecture／plan変更、規制イベント、およびBlueprintで定めたcadenceに合わせて、証跡に基づくマチュリティ評価を行います。
    2.  **Target Profile**: production gateは単一のlevel名ではなく、data class、criticality、team size、regulation、recovery requirementに必要なcontrolをBlueprintで定義します。未達controlはowner、期限、compensating control、承認を持つ例外として扱います。
    3.  **Gap Analysis**: 現在の能力とtarget profileのgapをrisk順に整理し、本ドキュメントの該当セクションへtraceします。
-   **Rationale**: 成熟度モデルは「何を改善すべきか」の優先順位を明確にし、闇雲なルール適用を低減します。段階的なアプローチにより、チームの負荷を適切に管理しながら運用品質を向上させます。

---

## Appendix A: サービス別逆引き索引

> **目的**: 60セクション・200+ルールの中から対象サービスのルールを即時発見するための逆引き索引。

| Supabaseサービス | 関連セクション |
|:----------------|:--------------|
| **PostgreSQL / Database** | §2, §4, §9, §31, §36, §38, §40, §42, §54, §55 |
| **RLS (Row Level Security)** | §3, §5.1, §8.3, §11.3, §12.3, §12.6, §19.1, §29.1, §38.1, §43 |
| **Auth (GoTrue)** | §5, §5.2, §12.1, §18, §25.1, §33, §35, §39, §44 |
| **Storage** | §6, §6.1, §6.2, §2.11, §58 |
| **Edge Functions** | §13, §19.2, §25.2, §53 |
| **Realtime** | §14, §37.2 |
| **pg_cron / Cron** | §15.1 |
| **Queues (pgmq)** | §15.2, §53 |
| **Database Webhooks** | §15.3, §53 |
| **Managed CDC / Pipelines** | §15.4 |
| **Migrations** | §7, §11.5, §11.9, §12.2, §40, §51 |
| **Type Safety** | §2.3, §11.4, §12.4, §57 |
| **FinOps / Cost** | §16.3, §58 |
| **Observability / Monitoring** | §16.1, §16.2, §16.4, §32, §36.2 |
| **pgvector / AI** | §17, §55, §56 |
| **MFA / PKCE / Passkeys** | §18.2, §44 |
| **Testing** | §19, §51 |
| **Branching / Environments** | §20, §51 |
| **PostgREST / REST API** | §21, §28, §30.2, §47 |
| **CLI / Local Dev** | §22, §40.2, §51 |
| **Connection Pooling / Supavisor** | §23, §41, §49 |
| **Backup / DR** | §24, §60 |
| **Rate Limiting / API Protection** | §25, §48 |
| **Vault / Secret Management** | §26 |
| **Foreign Data Wrappers** | §27 |
| **Data API Hardening** | §28, §47 |
| **Multi-tenancy** | §29, §54 |
| **pg_graphql / GraphQL** | §30 |
| **DB Functions / Triggers** | §31, §52 |
| **Log Drain / External Observability** | §32 |
| **Auth Hooks / Custom Claims** | §33 |
| **Self-hosted / Email** | §34 |
| **SSR / Framework Integration** | §35 |
| **Database Extensions** | §36, §55 |
| **Client SDK / supabase-js** | §37, §57 |
| **Schema Design Patterns** | §38 |
| **Social Auth / OAuth / SSO** | §39 |
| **Data Migration / Seeding** | §40 |
| **Multigres / Horizontal Scaling** | §41 |
| **PostgreSQL 18 / UUIDv7 / AIO** | §42 |
| **Column-Level Security** | §43 |
| **Passkeys / Biometric Auth** | §44 |
| **MCP Server / AI Development** | §45, §56 |
| **Security Advisor** | §46 |
| **Per-Table API Control** | §47 |
| **VPC / Private Link / Network** | §48 |
| **Read Replicas / Load Balancing** | §49 |
| **Project-scoped Roles / Team** | §50 |
| **CI/CD / Delivery Provider** | §51 |
| **Advisory Locks / Concurrency** | §52 |
| **Webhook / Event-Driven** | §53 |
| **Database Partitioning** | §54 |
| **Full-Text Search / pg_trgm** | §55 |
| **AI SQL / Generated SQL** | §56 |
| **End-to-End Type Safety** | §57 |
| **CDN / Edge Caching** | §58 |
| **Compliance / Data Sovereignty** | §59 |
| **Operational Maturity** | §60 |

### 内部クロスリファレンス

-   **冪等マイグレーション**: §7.4（基礎）→ §11.5 / §12.2（発展）→ §51（CI/CD自動化）
-   **RLS InitPlan最適化**: §3.0（Law 4: Scalar Subquery）→ §12.3.1 / §12.6（詳細実装）→ §46（Security Advisor）
-   **データアーカイブ**: §2.14（Cold Data Offloading）→ §2.13（Time-Series Partitioning）→ §2.18（Retention Protocol）→ §54（Advanced Partitioning）
-   **特権アクセス**: §11.6 / §12.1（Service Role）→ §3.0.2（Privileged Access）→ §12.7（Client Identity Audit）→ §50（Project-scoped Roles）
-   **認証セキュリティ**: §5（Auth基礎）→ §5.1（RLS by Default）→ §5.2（Session管理）→ §18.1（APIキー）→ §18.2（PKCE/MFA）→ §44（Passkeys）→ §33（Auth Hooks）→ §35（SSR統合）→ §39（Social Auth）
-   **ストレージ**: §6（基礎）→ §6.1（S3互換）→ §6.2（Image Transformations）→ §2.11（孤立ファイル防衛）→ §58（CDN/Edge Caching）
-   **パフォーマンス最適化**: §4（基礎）→ §42（PostgreSQL 18 AIO/UUIDv7）→ §49（Read Replicas）→ §54（Partitioning）→ §55（Full-Text Search）→ §41（Multigres）
-   **セキュリティ多層防御**: §3（RLS）→ §43（CLS）→ §48（VPC/Private Link）→ §47（API制御）→ §46（Security Advisor）→ §28（Data API Hardening）
-   **AI統合**: §17（pgvector/AI Search）→ §45（MCP Server）→ §56（AI SQL Governance）
-   **CI/CD統制**: §7（Migration基礎）→ §51（Provider-neutral CI/CD）→ §19（テスト）→ §20（Branching）→ §57（型安全E2E）
-   **コンプライアンス**: §11.1（Data Residency）→ §59（Compliance Framework）→ §2.18（Retention）→ §43（CLS）→ §26（Vault）
-   **運用成熟度**: §60（Maturity Model）→ 全セクション

### クロスリファレンス（他ルールファイル）

| セクション | 関連ルール |
|-----------|-----------|
| §3（RLS / セキュリティ） | `security/000_security_privacy`, `security/100_data_governance` |
| §5（認証） | `security/000_security_privacy` |
| §7（マイグレーション / CI/CD） | `engineering/000_engineering_standards`, `quality/000_qa_testing` |
| §17（pgvector / AI検索） | `ai/000_ai_engineering` |
| §19（テスト） | `quality/000_qa_testing` |
| §28（Data API Hardening） | `engineering/100_api_integration` |
| §42（PostgreSQL 18） | `engineering/000_engineering_standards` |
| §59（コンプライアンス / データ主権） | `security/100_data_governance`, `security/300_ip_due_diligence` |

---

## Appendix B: 公式資料スナップショット

- [Supabase Changelog](https://supabase.com/changelog.md): 時点依存のplatform、managed CDC／Pipelines、API key、Data API変更
- [Edge Functions recursive and nested call limits](https://supabase.com/changelog/43644-edge-functions-rate-limits-on-recursive-nested-edge-functions-calls): direct recursion、function chaining、circular call、fan-outへ適用されるrequest-chain共有limitと再検証境界
- [Management API `logs.all` endpoint migration](https://supabase.com/changelog/48235-migration-of-supabase-management-api-logs-all-analytics-endpoint-to-logs-endpoin): log automationのendpoint廃止期限と移行確認
- [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security): RLS、bypass、performanceの公式境界
- [Migrating to publishable and secret API keys](https://supabase.com/docs/guides/getting-started/migrating-to-new-api-keys): credential classとlegacy key移行
- [Securing the Data API](https://supabase.com/docs/guides/api/securing-your-api): exposed schema、grant、RLSの分離
- [Database Backups](https://supabase.com/docs/guides/platform/backups): 実効plan capability、PITR、restore判断
- [Self-hosted Changelog](https://supabase.com/changelog?tags=self-hosted): API gateway、distribution、breaking changeの時点確認
