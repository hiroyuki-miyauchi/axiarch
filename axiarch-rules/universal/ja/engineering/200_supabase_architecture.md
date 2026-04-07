# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「データは企業の血液である。その流れと保護に一切の妥協は許されない。」
> Supabase/PostgreSQLの実装において、**セキュリティ(RLS) > データ整合性 > パフォーマンス > 開発生産性 > コスト効率** の優先順位を厳守せよ。
> この文書はバックエンド・データ戦略に関するすべての設計判断の最上位基準である。
> **60セクション・200+ルール構成。**

---

## 目次

- §0. データ主権法と至高の命令 (Supreme Directives)
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
- §51. GitHub Actions CI/CD
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

## 0. データ主権法と至高の命令 (Data Sovereignty Law & Supreme Directives)

### Supreme Directive 0.1: The Zero Tolerance Linter Protocol
-   **Law**: Database Linter（Supabase Security Advisor等）の警告は、「提案」ではなく**「脆弱性報告」**です。
-   **Mandate**:
    1.  **Zero Warnings**: 本番環境へデプロイされるスキーマは、Linter警告が **常に 0件** でなければなりません。1件でもあればリリース不可とします。
    2.  **Universal Fix**: "Search Path Mutable" や "Permissive Policy" などの警告は、議論の余地なく**機械的に即修正**してください。プロジェクト固有の事情による例外は認められません。

### Supreme Directive 0.2: The Trinity DTO Mandate
-   **Purpose**: データ構造の堅牢性とスケーラビリティを保証するための三位一体の義務。
    -   **Security**: 生データの流出を物理的に防ぐ (White-list Output)。
    -   **Stability**: DB変更からフロントエンドを守る (Mapper Shield)。
    -   **AI Economy**: AIトークンを節約する (Data Minimization)。
    -   **Universality**: 言語を問わないエンジニアリングの**鉄則**です。

### Supreme Directive 0.3: Omnichannel Data Principle (API First)
-   **Principle**: データ構造は、単一のWebアプリだけでなく、ネイティブアプリ、外部システム、AIエージェントからも消費されることを前提に設計しなければなりません。
-   **Mandate**:
    -   **Universal Types**: 特定のUIフレームワークに依存したデータ型（React Nodeなど）をDBに保存してはなりません。
    -   **Neutral JSON**: JSONデータは、表示ロジックを含まない「純粋なデータ」として管理してください。

### Supreme Directive 0.4: The Client DTO Barrier（クライアントDTO障壁）
-   **Law**: データベースの行データ（Raw Entity）を、クライアントサイドコンポーネント（`use client` 等）のPropsとして**直接渡すことを禁止**します。
-   **Mandate**:
    -   **Server-Side Transformation**: 必ずサーバー側で目的に応じた軽量なDTOへ変換し、必要最小限のフィールドのみをクライアントへ送信してください。
    -   **PII Exclusion**: `admin_notes`, `phone_number`, `email` 等のPIIや内部管理フィールド（`deleted_at`, `internal_memo`）がブラウザへ到達することを物理的に防いでください。
    -   **Payload Minimization**: 不要なフィールドの送信は、ネットワーク帯域の浪費と、将来のデータ漏洩リスクの二重の問題を引き起こします。
-   **Rationale**: SD 0.2（Trinity DTO Mandate）が定義するDTO化義務の具体的な境界線として、クライアントコンポーネントへのデータ受け渡しを物理的な遮断点として確立します。Raw Entityの直接送信は、意図しないPII漏洩の最大のリスク源です。

### Core Laws
-   **SSOT (Single Source of Truth)**: 設定値、ユーザーデータ、コンテンツはすべて **PostgreSQL (`public` schema)** を唯一の正 (Source of Truth) とします。JSONファイルや外部CMSへの「二重管理」は厳禁です。
    -   **Prohibition**: 「とりあえずJSONで持つ」はデータの反逆です。
-   **Migration Only**: DBスキーマ変更は、必ずコード化された `supabase/migrations` 経由で行います。管理画面（Supabase Dashboardの SQL Editor 等）での手動変更は「履歴の破壊行為」とみなします。
-   **Migration Immutability Law (Sanctuary)**:
    -   **Law**: `supabase/migrations/*.sql` は、一度コミットされた瞬間から「聖域」となり、**リネーム・編集・削除を永久に禁止**します。
    -   **Felony**: リモートDB適用後の修正は、必ず「新規ファイル」で行うこと。過去の改竄は**即死級の重罪 (Instant Felony)** とみなします。

---

## 1. ハイブリッドスタック責務 (Hybrid Stack Responsibility)
-   **The Hybrid Stack**:
    -   **Edge (Cloudflare)**: **Shield & Optimize**. DDoS防御、WAF、画像リサイズ、静的アセットキャッシュを担当します。ロジックは持たせません。
    -   **Frontend (Vercel)**: **Router & Renderer**. ステートレスなUIレンダリングとAPIルーティングを担当します。CPU高負荷処理（画像加工・AI待機）は禁止です。
    -   **Backend (Supabase)**: **Source of Truth**. DB、Auth、ストレージ（Origin）、非同期ジョブ（Edge Functions）を担当します。

---

## 2. データベース設計基準 (Database Design Standards)

### Rule 2.0: The Realism Mandate (Anti-Haribote Protocol)
-   **Prohibition**: DB上にカラムが存在しない、または `jsonb` 内に定義が曖昧なデータを、あたかも正規化されたデータであるかのように扱うUIを実装してはなりません。
-   **Requirement**: 重要なビジネスロジック（財務、権限、状態遷移）に関わる属性は、必ず正規化されたカラム (`numeric`, `text`, `boolean`) として定義し、物理的な格納場所を確保してからUIを実装すること。
-   **Anti-Pattern**: 「とりあえずUIを作って、保存はあとで」は許されません。UIとデータは不可分の原子（Atom）として同時にリリースされなければなりません。

### Rule 2.0.1: The Settings Column Architecture (No JSON Blob)
-   **Law**: サイト設定やシステム設定は、単一のJSON/JSONBカラム（`config: jsonb`）への詰め込みを禁止し、**正規化されたカラム**で管理してください。
-   **Reason**:
    1. **Query Performance**: SQLによる高速なWHERE句や集計が可能になります。
    2. **Type Safety**: TypeScript/zodでの型推論が正確になり、「未定義キー」エラーを防ぎます。
    3. **Integrity**: 外部キー制約やCHECK制約の適用が可能になります。
-   **Migration**: 新しい設定項目追加時は、必ずDBマイグレーションを行ってください。
-   **Exception (Dynamic Label Isolation Protocol)**: 以下のケースに限り、JSONBカラムの使用を例外的に許可します。ただし、そのJSONBカラムの責務を厳密に限定し、正規化すべきデータの混入を禁止します。
    1.  **動的ラベル・翻訳**: 多言語対応のUI表示ラベル、カスタム評価項目名等、スキーマ設計時に項目数が確定しない動的テキスト。
    2.  **検索不要な可変長配列**: 表示順序のみが重要で、SQLのWHERE句やJOINでの検索対象にならないリスト。
    3.  **禁止**: `max_count`, `threshold` 等の計算・検索・条件分岐に使用されるプロパティをJSONBに含めることは禁止です。これらは必ず正規化カラムに昇格させてください。

### Rule 2.1: Integrity & Ownership
-   **RLS Absolute**: 行レベルセキュリティ (RLS) は絶対です。`service_role` キーの使用は原則禁止とし、全てのクエリはRLSを経由させます。
-   **Hierarchical Resource Ownership (階層的リソース所有権)**:
    -   **Context**: 家族共有、チームプロジェクトなど、単一所有者（`user_id`）では表現できない複雑な所有権構造。
    -   **Law**: 複数ユーザーがリソースへアクセスする場合、中間テーブル（例: `resource_members`）を通じて権限（`role: 'viewer'|'admin'`）を定義し、RLSポリシーでこの関係テーブルを参照してアクセス制御を行います。
    -   **Action**:
        1.  **Owner ID**: 主たる所有者は `owner_id` として保持。
        2.  **Role-Based**: 中間テーブルで権限を管理。
        3.  **Inheritance**: 子リソースは親リソースへのアクセス権を `EXISTS` 句で継承し、二重のセキュリティを保証。
-   **PII Encryption**: 極めて機密性の高い個人情報（口座、書類番号等）は、Vaultやpgcryptoを用いて暗号化保存することを推奨します。

### Rule 2.2: Schema & Type Standards
-   **Schema Separation**: `public` (App Data), `extensions` (PostGIS等), `admin` (監査ログ・管理ビュー) を厳格に分離し、`extensions` を `public` にインストールすることを禁止します。
-   **System Schema Immunity**: `storage`, `auth`, `graphql` などのシステムスキーマ内のテーブルに対して、`ALTER TABLE` などのDDL操作を行うことは原則禁止です（権限エラー `42501` の原因）。
-   **Constraints**:
    -   **Identity**: 自動採番には `SERIAL` ではなく `GENERATED BY DEFAULT AS IDENTITY` を使用します。
    -   **Money**: 金額には `numeric`/`integer` を使用し、`float` は完全禁止。
    -   **Boolean**: `NOT NULL DEFAULT false` を徹底。

### Rule 2.3: Type Safety Protocol (The Bridge)
-   **Automated Types**: `supabase gen types` で生成された `database.types.ts` を使用します。
-   **The Mapped Type Bridge Mandate**:
    -   **Law**: 拡張型 (`DatabaseExtended`) を定義する際、交差型 (`&`) は禁止です（推論競合リスク）。
    -   **Action**: 必ず **Mapped Type (写像型)** を使用し、`keyof Database` を反復しながら物理的に上書き (Override) する形で定義し、100%の型安全性を確保してください。

### Rule 2.4: The New Table Checklist (Creation Protocol)
-   **Law**: 新規テーブル作成時は、以下の項目を全て満たすことを完了条件とします。
    - [ ] **RLS Enable**: `alter table ... enable row level security;` を実行したか？
    - [ ] **Policy**: 最低でも `TO service_role` のポリシーが存在するか？（デフォルト拒否の回避）
    - [ ] **Index**: 外部キー (`*_id`) にインデックスを貼ったか？
    - [ ] **Type**: `database.types.ts` を再生成し、型定義を更新したか？
    - [ ] **Audit**: `audit_logs` へのトリガーを設定したか？（重要テーブルの場合）

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
    1.  **Retention Category Definition**: 全データテーブルを以下のカテゴリに分類し、保持期間を明示的に定義してください。
        | カテゴリ | 例 | 推奨保持期間 |
        |---|---|---|
        | アクティブデータ | ユーザー、コンテンツ | 無期限（退会まで） |
        | トランザクションログ | 決済記録 | 法定保持期間（例: 7年） |
        | アクセスログ | リクエストログ、トレース | 90日 |
        | セッションデータ | セッション、トークン | 30日 |
        | 一時データ | OTPコード、アップロード一時ファイル | 24時間 |
        | 分析データ | アナリティクスイベント | 2年（集約後サマリーへ） |
    2.  **Automated Purge**: `pg_cron` やクラウドスケジューラ等を使用し、保持期限を超過したデータを自動的に削除・アーカイブするバッチジョブを実装してください。
    3.  **Account Deletion Lifecycle**: ユーザー退会時は、段階的なデータ処理を実装してください：
        -   即時: プロフィール情報の非公開化
        -   30日後: 論理削除（`deleted_at` 設定）
        -   法定保持期間後: 物理削除またはPII完全匿名化
    4.  **Purge Logging**: パージ実行の記録（対象テーブル、削除件数、実行日時）を監査ログに残してください。
-   **Rationale**: データを無期限に保持することは、ストレージコストの増大、プライバシーリスクの拡大、そしてGDPR/APPI等のデータ最小化原則への違反を招きます。保持期間の自動管理により、コスト・コンプライアンス・パフォーマンスの三方良しを実現します。

---

## 3. インテグリティとロジック戦略 (Integrity & Logic Strategy)

### Supreme Directive 3.0: The RLS Implementation Iron Rules
-   **Law 1: Atomic Action Definition**
    -   `FOR INSERT, UPDATE` のようなカンマ区切り定義は禁止。`FOR ALL` 以外は、必ず**アクションごとに個別のポリシー**として定義してください。
-   **Law 2: INSERT Syntax Discipline**
    -   `INSERT` ポリシーは必ず **`WITH CHECK`** を使用してください（`USING` は不可）。
-   **Law 3: Zero Guessing Protocol**
    -   SQL作成前には必ずスキーマ定義ファイルを読み込み、**カラム名を指差し確認**してください。推測による実装は厳禁です。
-   **Law 4: Performance Safety (Scalar Subquery Mandate)**
    -   **Law**: `auth.uid()` や `current_setting()` などの関数呼び出し、およびポリシー内での他テーブル参照は、必ず **`(select auth.uid())`** 形式のスカラーサブクエリでラップし、評価の固定（Plan Dynamic InitPlan化）を強制してください。
    -   **Reason**: ラップしない場合、Postgres 行ごとにその関数を再評価（N+1評価）し、データ量が増加した際に CPU 使用率のスパイクとクエリ遅延を招く「隠れた爆弾」となります。

### Rule 3.0.1: The RLS Helper Functions Registry (RLS Utility)
-   **Security Definer Isolation**: RLS ポリシー内で自分自身（テーブル）を参照すると無限再帰（`42P17`）が発生します。admin 判定等の複雑なチェックは必ず `SECURITY DEFINER` 関数で分離してください。
-   **The Qualified Schema Mandate (RPC Security)**:
    -   **Law**: `SECURITY DEFINER` 関数内で `SET search_path = ''` を適用する場合、`public` スキーマの修飾がないテーブル参照は全てエラーとなります。
    -   **Action**: 関数内部では一文字の妥協もなく `public.profiles`、`public.reviews` と記述することを義務付けます。これを怠ることはシステムの「可用性の破壊」です。
    -   **Registry Standards**:
        -   `public.is_admin()`: 管理者チェック。
        -   `public.is_owner(resource_id)`: 所有者チェック。
        -   **Requirement**: ヘルパー関数は必ず **`SECURITY DEFINER`** 属性を付与し、かつ **`SET search_path = ''`** で検索パスを物理的に断ち切ってください。これにより、関数内部でのテーブル・関数参照は全てスキーマ修飾（例: `public.table_name`）を義務付け、Search Path 汚染によるインジェクション攻撃を物理的に不可能なレベルで排除します。

### Rule 3.0.2: The Admin RLS Mandate (The "Locked Out" Lesson)
-   **Context**: 「一般ユーザー権限」だけのポリシー（例: `user_id = auth.uid()`のみ）を書くと、管理者がそのテーブルを操作できなくなり、データ修正作業で詰みます。
-   **Law**: 全てのRLSポリシーにおいて、**「管理者は常にアクセス可能」** という例外条項を含めることを義務付けます。
-   **Pattern**:
    ```sql
    -- 必ず "OR is_admin()" を含める (DRY原則)
    ON public.posts
    FOR UPDATE
    USING (
      (user_id = auth.uid() AND ...)  -- 一般ユーザー条件
      OR
      (SELECT is_admin()) -- 管理者バイパス
    );
    ```
    ※ `is_admin()` ヘルパー関数は `profiles` テーブル等をチェックする `SECURITY DEFINER` 関数として実装すること。

### Rule 3.0.3: The RLS Recipes (Implementation Standards)
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
    2.  **Write Policy**: 書き込み権限は `FOR INSERT/UPDATE/DELETE` 専用ポリシーとし、**絶対に `SELECT` を含めてはなりません**。
-   **Admin Strictness**: 「管理者だから全部OK」の `FOR ALL` は原則禁止。

### Rule 3.2: Permissive Policy Consolidation
-   **Consolidation**: 「Admin権限」と「一般参照権限」などは可能な限り1つのポリシー内に `OR` 条件で統合し、ポリシー総数を削減してください。
-   **Efficiency**: 重複するポリシー（例：「Public View」と「Everyone View」）は即削除。

### Rule 3.3: Data Integrity Patterns
-   **Soft Delete**: 主要データは `deleted_at` による論理削除とし、ユニーク制約には `WHERE deleted_at IS NULL` を付与。
-   **The Right to be Forgotten (Soft Delete Exception)**:
    -   **Context**: 原則は論理削除ですが、ユーザーからの明示的な「アカウント削除リクエスト」および GDPR/Apple 要件に対しては、物理削除または完全匿名化（PII抹消）を行う義務があります。
    -   **Action**: 退会処理においては `deleted_at` だけでなく、個人特定情報を物理的に削除するか、不可逆的にマスク (`deleted_user_xyz`) してください。
    -   **Atomic Update**: リッチテキストは `_json` (Editor), `content` (View), `search_text` (Search) の3カラムへ同時保存。
    -   **No SQL Replace**: JSON内の文字列置換をSQLで行うことは禁止。

### Rule 3.3.1: The CMS Triple Write Protocol (Search Consistency)
-   **Context**: CMSコンテンツ（店舗名、記事タイトル等）は、「表示用」「編集用」「検索用」で要件が異なります。
-   **Law**: 重要なテキストデータは、1つのカラムに統合するのではなく、以下の3つの役割に分割して原子的に保存（Triple Write）することを標準とします。
    1.  **`name_display`**: 表示用（絵文字、装飾を含む）。
    2.  **`name_kana`**: ソートおよび読み仮名用（半角カナ等で正規化）。
    3.  **`name_search`**: 全文検索用（n-gramトークン化、または検索用メタデータ）。
-   **Automated Sync**: これらはフロントエンドからの送信時に同期させるか、可能であればDBトリガーで自動生成し、不整合（名前を変えたのに検索できない等）を物理的に防いでください。

### Rule 3.3.2: The Multiple Permissive Policies Conflict (Policy Hygiene)
-   **Law**: 同一テーブル、同一アクション（例: `SELECT`）に対して、複数の `PERMISSIVE` ポリシーが存在する場合、Postgres はそれらを `OR` で結合します。これは意図しないアクセス許可（穴）を生む原因となります。
-   **Action**: 新しいポリシーを追加する際は、必ず既存のポリシーを `DROP` するか、または「1つの統合されたポリシー」に整理してください。「適当に新しいのを追加して動いたからOK」という態度は、セキュリティエンジニアとして失格です。
-   **Verification**: `select * from pg_policies where tablename = '...';` で、意図した数（通常はアクションごとに1つ）であることを物理的に目視確認する義務があります。

### Rule 3.4: RLS Lifecycle Management Protocol
-   **Create-Verify-Drop Trinity (作成・検証・削除の三位一体)**:
    1.  **Before Create**: 新ポリシー追加前は必ず `SELECT policyname FROM pg_policies WHERE tablename = '...'` で現状を把握せよ。
    2.  **After Apply**: マイグレーション適用後、Dashboard の `Security Advisor` で `multiple_permissive_policies` が 0 件であることを物理的に確認せよ。
    3.  **Cleanup**: 重複したポリシー（Same Action, Same Table）が発見された場合、標準命名規則に従ったものを残し、他は **`DROP POLICY IF EXISTS "..." ON ...;`** で原子的に（同一マイグレーション内で）削除せよ。
-   **Naming Convention**: `"Public can view..."` 等の自然言語による命名を禁止します。**`tablename_action_policy`** 形式（例: `posts_select_policy`）での完全統一を義務付けます。
-   **Atomic Migration**: 新ポリシー作成と旧ポリシー削除は、常に**同一マイグレーションファイル**で原子的に実行してください。不整合期間が 1 ミリ秒でも存在することを許しません。
-   **Incident Prevention Checklist**:
    - [ ] 既存ポリシー一覧を確認したか？
    - [ ] 命名規則に従っているか？
    - [ ] レガシーポリシーの `DROP` を同一マイグレーションに含めているか？
    - [ ] `DROP POLICY` の名称は推測ではなく、DB上の実名と完全一致しているか？
    - [ ] **The Copy-Paste Mandate**: ポリシー名を手入力（タイピング）したか？ → YESならReject。必ずDashboard/SQLからコピペせよ。一字一句の不一致も許されない（Exact Policy Name Match Protocol）。
    - [ ] デプロイ後に Security Advisor 警告数を確認したか？
-   **Strictification Drop Mandate（厳格化時のDROP義務）**:
    -   **Warning**: RLSポリシーは**加算（OR）方式**で評価されます。既存のPermissiveポリシー（例: `USING (true)` の「誰でもOK」ルール）が残ったまま厳格なポリシーを追加しても、既存の緩いポリシーが優先され**新しいポリシーは実質無効化**されます。
    -   **Action**: セキュリティ強化マイグレーションでは、新しい厳格ポリシーを作成する**前に**、必ず `DROP POLICY IF EXISTS "旧ポリシー名" ON ...;` を実行し、既存の穴を物理的に塞いでください。
    -   **Template**:
        ```sql
        -- Step 1: 既存の緩いポリシーをDROP（必須）
        DROP POLICY IF EXISTS "legacy_permissive_policy" ON public.target_table;
        -- Step 2: 新しい厳格ポリシーを作成
        CREATE POLICY "target_table_select_policy" ON public.target_table
        FOR SELECT USING (strict_condition);
        ```

### Rule 3.5: Public Read Protocol (Anti-Vault Paradox)
-   **Principle**: 「セキュリティ」とは機能不全にすることではない。
-   **Law**:
    1.  **Public Read**: 非公開にする理由がないデータ（公開記事、店舗情報、システム設定の公開キー）は `FOR SELECT USING (true)` で積極的に開放。
    2.  **Strict Write**: 書き込み（`INSERT/UPDATE/DELETE`）は引き続き厳格にロック。
    3.  **Separation**: 読み取り（SELECT）と書き込み（WRITE）の権限を混同し、「書き込みを守るついでに読み取りまで塞ぐ」愚を犯さないこと。

---

## 4. パフォーマンスとスケーラビリティ (Performance & Scalability)

### Rule 4.1: Indexing Hygiene Protocol
-   **FK Indexing**: 外部キー (FK) には**必ず**インデックスを作成します（JOIN最適化）。インデックスなきFKは「パフォーマンスの負債」です。
-   **Naming Convention**: `idx_<table_name>_<column_name>` 形式で統一（例: `idx_posts_user_id`）。
-   **Unused Purge**: 
    1. 定期的に `unused_index` 警告を確認し、読み取り負荷の軽減に貢献していない「死んだインデックス」は、書き込みパフォーマンス向上のために即座に削除せよ。
    2. ただし、開発初期や小規模データ時に「現在未使用」という理由だけで削除しないこと。インデックスは「冬用の備え」であり、データ増加を待って判断せよ。

### Rule 4.2: Japanese Search Optimization
-   日本語全文検索には `pg_search` (tsvector) または `pgroonga` を使用します。

### Rule 4.3: Scalability Strategy
-   **Infinite Scalability**: `select('*')` および上限なしクエリは禁止。必ずページネーションを実装。
-   **Post-Query Filter Prohibition**: ページネーション付きクエリの結果に対して、アプリケーション側（JavaScript/TypeScript）でフィルタリングを行うことを禁止します。フィルタ条件は必ずSQLのWHERE句に含めてください。JS側フィルターを適用すると、1ページあたりの表示件数が不定になり、ページネーションの総件数・総ページ数も不正確になります。
-   **Partitioning**: テーブルレコード数が **1,000万件 (10M)** を超える予測で `pg_partman` を導入。
-   **Read Replica**: 分析クエリはReplicaへオフロード。
-   **Archival**: コールドデータはオブジェクトストレージへ退避。
-   **Connection Pooling（接続プール最適化）**:
    -   **Law**: データベース接続数はPostgreSQLの最大接続数に制約されるため、コネクションプーリングツール（PgBouncer等）を活用してDB接続数を最適化しなければなりません。
    -   **Action**:
        1.  **Pooler Mandatory**: サーバーレス環境（Edge Functions, Vercel Serverless等）からのDB接続は、必ずコネクションプーラー経由としてください。関数のコールドスタートごとに新規接続を作成すると、接続数が爆発的に増加します。
        2.  **Transaction Mode**: 短寿命のリクエスト処理には `Transaction Mode`（リクエスト単位で接続を解放）を使用してください。`Session Mode` はPrepared Statementsが必要な場合に限定します。
        3.  **Max Connections Guard**: アプリケーション側の接続プールサイズは、DBの `max_connections` の**70%以下**に設定し、管理ツールやバックグラウンドジョブへの接続余裕を確保してください。
    -   **Rationale**: サーバーレスアーキテクチャでは同時接続数がスパイク的に増加します。コネクションプーラーなしではDB接続数が上限に達し、全サービスが接続エラーで停止するリスクがあります。

### Rule 4.4: The Optimistic Mutation Protocol（楽観的更新プロトコル）
-   **Law**: ネットワーク遅延により操作から反応までに0.5秒以上のラグが生じる高頻度アクション（いいね、ステータス変更、並び替え等）には、サーバー応答を待たずにUIを即時更新する**楽観的UI（Optimistic UI）**を実装しなければなりません。
-   **Action**:
    1.  **Instant Feedback**: ユーザーの操作直後にローカルStateまたは楽観的更新フック（例: React の `useOptimistic`）を使用してUIを即時更新してください。サーバーレスポンスを待ってからUIを更新するパターンは、ユーザーに「壊れている」という印象を与えます。
    2.  **Rollback on Error**: サーバーエラー発生時は、即座に元の状態にロールバックし、トーストまたはスナックバーでエラーを通知してください。
    3.  **Scope**: 全ての操作に適用する必要はありません。適用対象は「反復的かつ高頻度な操作」に限定し、決済や削除など不可逆な操作には使用しないでください。
-   **Rationale**: 0.5秒以上のUIフリーズはユーザーに「壊れている」という印象を与え、離脱率の増加を招きます。楽観的更新により体感速度を劇的に改善し、アプリの品質感を向上させます。

---

## 5. 認証とセキュリティ (Auth & Security)
-   **Gotrue Delegation**: 認証はSupabase Authに完全委任。
-   **Notification Architecture**:
    -   **Aggregation**: 同一リソースへの重複アクション（例: 複数人のいいね）は、通知テーブルで「集約」し、通知爆撃を防ぎます。
    -   **Async Delivery**: メール送信等は非同期ジョブ (`pgmq`等) を経由させます。
    -   **The Smart Notification Control Protocol (Email Bomb Prevention)**:
        -   **Law**: メール通知は即時送信せず、ジョブキューを介して数分〜数十分遅延させてください。
        -   **Logic**: 送信直前に「アプリ内で既読になっているか」をチェックし、既読の場合はメール送信をスキップします。
        -   **Outcome**: 「既にアプリで確認した内容のメールが後から届く」というUX劣化を防ぎ、メール爆撃による離脱を回避します。

### Rule 5.1: The RLS-by-Default Enforcement Protocol（2025年新標準）
-   **Law**: 2025年のSupabaseアップデートにより、新規テーブルには**RLSがデフォルトで有効**となります。この挙動を前提に、テーブル作成直後にポリシーを定義する運用を徹底しなければなりません。
-   **Action**:
    1.  **Immediate Policy**: テーブル作成後、ポリシー未定義の状態で放置しないでください。RLS有効 + ポリシーなし = **全アクセス拒否**です。開発中であっても最低限 `TO authenticated` のポリシーを設定してください。
    2.  **Event Triggers**: Supabaseの **Event Triggers** 機能を活用し、新規テーブル作成時に自動的にRLSを有効化するトリガーを設定してください。人為的な設定漏れを物理的に防止します。
    3.  **Dashboard Alerts**: ダッシュボードの **Security Alerts** で「RLSが無効なテーブル」の警告が表示された場合、即座に対処してください。これは §0.1（Zero Tolerance Linter Protocol）の適用対象です。
    4.  **Exposed Tables**: RLSが有効でもポリシーが `USING (true)` のテーブルは実質的に全公開です。ダッシュボードの **Exposed Tables** ラベルを定期的に確認し、意図しない公開がないか監査してください。

### Rule 5.2: The Session & Token Management Protocol
-   **Law**: Supabase Authのセッションとトークン管理は、セキュリティとUXのバランスを考慮して適切に設計しなければなりません。
-   **Action**:
    1.  **Token Refresh**: `supabase.auth.onAuthStateChange()` を必ず実装し、`TOKEN_REFRESHED` イベントでセッションを自動更新してください。未実装の場合、ユーザーが突然ログアウトされるUX障害が発生します。
    2.  **JWT Expiry**: JWTの有効期限はデフォルト3600秒（1時間）です。短縮する場合は15分以上を推奨。5分未満はリフレッシュ頻度が過剰になり、パフォーマンス劣化の原因です。
    3.  **Server-Side Validation**: Server Components/Server ActionsでのJWT検証には、`supabase.auth.getUser()` を使用してください。`supabase.auth.getSession()` はJWTをローカルで検証するだけで、Auth サーバーとの同期を保証しません。**認証が必要な操作では必ず `getUser()` を使用してください。**
    4.  **Cookie-Based Auth**: Next.js等のSSRフレームワークでは、`@supabase/ssr` パッケージを使用してCookieベースのセッション管理を実装してください。LocalStorageベースのトークン管理はSSR環境では動作しません。

---

## 6. ストレージと配信 (Storage & Delivery)
-   **Cloudflare Proxy Shield**: 画像配信は必ずCloudflare経由。
-   **Bucket Separation**:
    -   **Public**: 店舗写真、アバター。CDNキャッシュ最大化。
    -   **Private**: 請求書、個人書類。**Signed URL** と厳格なRLSチェックが必須。
    -   **Ads**: 広告用バナーは別バケット (`bucket-ads`) に分離。
-   **User Upload Hygiene**: クライアントサイドでリサイズし、**GPS情報（EXIF）を削除**してからアップロード。
-   **The Signed Upload URL Mandate (Direct-to-Storage Pattern)**:
    -   **Law**: 大容量ファイル（画像、動画、ドキュメント）のアップロードにおいて、ファイルデータがアプリケーションサーバー（Vercel/Cloud Functions等）を経由することを禁止します。
    -   **Flow**:
        1. **Server Action**: 認証と権限チェックを行い、問題がなければStorageへの**Signed Upload URL**を発行してクライアントに返す。
        2. **Client Direct Upload**: クライアントから直接Storageへアップロードする。
    -   **Outcome**: アプリケーションサーバーのCPU/メモリ負荷を軽減し、Serverlessプラットフォームの転送量課金とタイムアウトリスクを回避します。

### Rule 6.1: The S3 Compatible Protocol（S3互換プロトコル）
-   **Law**: Supabase StorageのS3互換プロトコル（2024年GA）を活用し、S3互換ツール・ライブラリとの相互運用性を確保しなければなりません。
-   **Action**:
    1.  **S3 Client Access**: AWS SDK（`@aws-sdk/client-s3`）やその他のS3互換クライアントを使用してSupabase Storageにアクセスできます。`endpoint` にSupabase StorageのS3 URLを指定してください。
    2.  **RLS with JWT**: S3プロトコルでユーザーのJWTトークンを使用して認証した場合、Storage SchemaのRLSポリシーが**自動的に適用**されます。ユーザースコープのアクセス制御が可能です。
    3.  **Standard S3 Keys**: 標準のS3アクセスキーはRLSを**バイパス**し、全ファイルにフルアクセスを提供します。サーバーサイド専用とし、クライアントへの露出を厳禁とします。
    4.  **Use Case**: マルチパートアップロード（大容量ファイル）、既存S3ツール（aws cli、rclone等）からの移行、バックアップスクリプトなど、標準Supabase APIでは対応しにくいケースで使用してください。

### Rule 6.2: The Storage Image Transformations & CDN Protocol
-   **Law**: 画像配信においてはSupabase Storage **Image Transformations**（サーバーサイド画像変換）と **CDN** を活用し、クライアント側での無駄な帯域消費を防止しなければなりません。
-   **Action**:
    1.  **On-the-Fly Resize**: `supabase.storage.from('bucket').getPublicUrl('image.png', { transform: { width: 300, height: 200 } })` でサーバーサイドリサイズを活用。各デバイスに最適なサイズを配信し、帯域を節約してください。
    2.  **Format Conversion**: `format: 'webp'` オプションでWebP変換を実行。JPEG比で25-35%のファイルサイズ削減が可能です。
    3.  **CDN Cache**: Publicバケットのファイルは自動的にグローバルCDNでキャッシュされます。`Cache-Control` ヘッダーを適切に設定し、キャッシュヒット率を最大化してください。Privateバケットはユーザーごとの権限チェックが入るため、キャッシュヒット率は低下します。
    4.  **File Size Limits**: アップロード時にファイルサイズを制限してください（デフォルト最大50MB）。バケットの `fileSizeLimit` オプションで上限を設定し、不正な大容量ファイルのアップロードを防止してください。
    5.  **MIME Type Validation**: `allowedMimeTypes` でアップロード許可するファイルタイプを制限してください。画像バケットに`.exe`や`.js`がアップロードされることはセキュリティインシデントです。

---

## 7. 運用とマイグレーション (Operations & Migration)

### Rule 7.1: The Migration Protocol (Ghost Table Defense)
-   **Remote Execution**: 本番スキーマ変更はDashboardのSQLエディタ等で行い、実行ログを `supabase/migrations` に保存してGit管理します。
-   **Migration Timestamp Hygiene**:
    -   **Context**: 手動作成ファイルのタイムスタンプが「未来」だと、自動生成ファイルの順序が狂います。
    -   **Action**: 必ず `ls supabase/migrations` で**最新の既存タイムスタンプ**を確認し、順序整合性を保ってください。
-   **Atomic Migration**: `DROP POLICY` と `CREATE POLICY` は同一ファイル内で完了させ、セキュリティ空白期間を作らないこと。
-   **Ghost Table Defense**: 
    -   **Law**: 存在しないテーブルへの `ALTER` や `CREATE POLICY` はマイグレーションエラー (`42P01`) を引き起こします。
    -   **Action (Table Existence Verification Protocol)**: 外部依存や古いスキーマダンプを参考にする際は、必ず `DO $$` ブロックを用いた条件付き実行（`IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '...')`）を徹底してください。記憶や「あるはず」という思い込みでの実装を禁止します。
    -   **Column-Level Verification (Schema-Reality突合義務)**: マイグレーション作成前およびDTO設計時は、テーブルの存在だけでなく**カラムの存在・型・制約も`information_schema.columns`で確認**してください。カラム名の推測による実装（例：`dog_description_json`が存在しないのにDTOに定義）はSchema-Reality乖離の主因であり禁止です。
-   **Remote Schema Warning**: `remote_schema.sql` や生成ファイルは過去のスナップショットに過ぎません。SQL作成前は必ず現在のDB状態（Dashboard または `pg_tables` クエリ）を正として確認してください。

### Rule 7.2: IPv6 & CI/CD Protocol
-   **GitHub Actions**: ランナー環境でのIPv6接続エラーを防ぐため、`supabase link` (Connection Pooler) または `SUPABASE_DB_URL` 直接接続 (Plan C) を適切に使い分け、安定したデプロイ経路を確保してください。

### Rule 7.3: Data Seeding & Caching Determinism
-   **Seed Determinism**: 初期データ (`seed.sql`) は **固定ID・固定値** を使用し、決定論的なテスト状態を保証します。
-   **Cache Versioning**: マスターデータ等を `unstable_cache`等でキャッシュする場合、データの増減やスキーマ変更時に古いキャッシュが残る「Cache Rot」を防ぐため、キャッシュキーには必ずバージョンサフィックス（例: `master_data_v2`）を付与し、物理的に無効化する仕組みを設けてください。
-   **Verification**: シード実行後は、必ずアプリケーション経由またはクエリで実データ件数が期待通りか確認してください。CLIの「Up to date」はデータの存在を保証しません。

### Rule 7.4: Migration Idempotency Protocol
-   **Mandate**: マイグレーションは何度実行しても同じ結果になるよう設計すること。
-   **Implementation**:
    -   `CREATE TABLE IF NOT EXISTS`
    -   `DROP POLICY IF EXISTS` の後に `CREATE POLICY`
    -   `CREATE INDEX IF NOT EXISTS`
-   **Rationale**: CI/CDパイプラインでの再実行やロールバック後の再適用に対応。

### Rule 7.5: Cache Reload Protocol
-   **Context**: マイグレーション適用後、接続プールやORMのスキーマキャッシュが古い状態を保持する場合がある。
-   **Mandate**: 重大なスキーマ変更（カラム追加/削除、型変更）後は、以下を確認すること:
    1.  型定義ファイル（`database.types.ts` 等）の再生成
    2.  開発サーバーの再起動
    3.  本番環境でのサービス再起動またはコネクションプールのリフレッシュ

### Rule 7.6: The Zero SQL Editor Policy (History Protection)
-   **Law**: Supabase Dashboard の SQL Editor での **直接的な書き込み (INSERT/UPDATE/DELETE)** および **スキーマ変更 (DDL)** は、変更履歴が残らず、再現性が失われるため**完全禁止**です。
-   **Action**: 
    1. 修正や操作が必要な場合は、必ずローカルで `supabase migration new your_fix` を作成し、Git 経由でデプロイしてください。
    2. SQL Editor は、「現在値の確認」や「クエリのデバッグ」という参照専用（Read-only）として利用を制限してください。

### Rule 7.7: The Expand-Contract Migration Protocol（ゼロダウンタイム・スキーマ変更）
-   **Law**: 本番環境で稼働中のテーブルに対して破壊的なスキーマ変更（カラムのリネーム・型変更・削除、テーブルの再構築等）を行う場合、**Expand-Contract パターン**を用いてゼロダウンタイムで段階的に実施しなければなりません。
-   **Action**:
    1.  **Phase 1 — Expand（拡張）**: 新しいカラムまたはテーブルを**追加のみ**で作成してください。この段階では既存のカラム・テーブルを一切変更・削除してはならず、アプリケーションは旧構造のまま稼働し続けます。
    2.  **Phase 2 — Migrate（移行）**: 旧データを新カラム/テーブルへバックフィル（コピー・変換）してください。大量データの更新はバッチ処理で行い、単一トランザクションでの全件 `UPDATE` を避けてください。アプリケーションは新旧両方の構造をサポートする「デュアルライト（Dual Write）」を実装し、移行期間中のデータ整合性を保証してください。
    3.  **Phase 3 — Contract（縮退）**: 全アプリケーションが新構造のみを参照していることを確認した後、**最低1週間の安定稼働期間**を経てから旧カラム/テーブルを削除してください。
-   **Prohibition**:
    -   Expandフェーズで `DROP COLUMN` や `ALTER COLUMN ... TYPE` を実行することは禁止です。
    -   Contractフェーズの実行前に、旧構造への参照がコードベース全体に存在しないことを `grep` で物理的に確認してください。
-   **Rationale**: 「ALTER TABLE ... RENAME COLUMN」のような一見単純な操作でも、デプロイのタイミング差で旧コードが新スキーマにアクセスし、障害を引き起こします。Expand-Contractパターンにより、スキーマとアプリケーションの変更を時間的に分離し、安全なゼロダウンタイムマイグレーションを実現します。

### Rule 7.8: The Data-Aware Defense Protocol（データ依存防衛プロトコル）
-   **Law**: 本番DBには開発環境にない「汚れたデータ」（重複レコード、型不整合、不完全なデータ）が存在します。CI環境（クリーンなDB）はこの汚れを検知できないため、全てのDML（データ操作）は**「既にデータが存在する」前提**で防衛的に記述しなければなりません。
-   **Action**:
    1.  **Assumed Conflict**: 全ての `UPDATE` / `INSERT` は、「対象データが既に存在する」「重複している」前提で書いてください。楽観的な「きれいなDB」を前提にしたSQLは本番で爆発します。
    2.  **Defensive Logic**: 単純なSQLではなく、`DO $$ ... END $$` ブロックや `ON CONFLICT` 句を用い、例外発生をコードレベルで回避してください。
    3.  **Cleanup Before Constraint**: 一意制約（`UNIQUE`）を追加するマイグレーションでは、事前に重複データを削除・統合するクリーンアップロジックを**同一マイグレーションファイル内に**必ず含めてください。制約追加だけでは、本番の重複データがマイグレーションを失敗させます。
-   **Rationale**: 開発環境とCIでは「成功したマイグレーション」が、本番環境の汚れたデータで失敗するケースは非常に多いです。防衛的なDML記述により、全環境での安全なマイグレーションを保証します。

### Rule 7.9: The Migration Static Analysis Guard（マイグレーション静的解析ガード）
-   **Law**: マイグレーションファイルに含まれる危険なSQLパターンを**自動検出し、マージ前に拒否**する静的解析の仕組み（Pre-push Hook + CI Check）を導入しなければなりません。「人間の注意力」に依存する運用ルールは、緊急時や新任者によって必ず破られます。
-   **Action**:
    1.  **Pre-push Hook (Local Iron Dome)**: Git の pre-push hook で、`supabase/migrations/` 内の新規・変更ファイルを静的解析し、危険パターンが含まれている場合は Push を物理的に拒否してください。
    2.  **CI Check (Remote Concrete Wall)**: GitHub Actions 等のCIパイプラインで同等のチェックを実行し、ローカルフックをバイパスした場合でもマージを阻止する最終防衛線としてください。
    3.  **Detection Patterns (The Forbidden Patterns)**:
        -   `UPDATE` without `DO` block or `WHERE` with subquery → 防衛なき更新として拒否
        -   `INSERT` without `ON CONFLICT` → 一意制約違反リスクとして拒否
        -   `ADD CONSTRAINT ... UNIQUE` without prior cleanup → 既存データ不整合リスクとして拒否
    4.  **No Bypass**: `--no-verify` 等のフック回避オプションの使用は、プロジェクトのスキーマ信頼性を破壊する行為として禁止します。
-   **Rationale**: マイグレーションの安全性を人間の注意力に依存させることは、インシデントの「いつ起こるか」の問題に過ぎません。静的解析による物理的な防御壁を設けることで、危険なSQLが本番環境に到達することを構造的に不可能にします。

---

## 8. 保守と堅牢化 (Maintenance & Hardening)

### Rule 8.1: Security Hardening (The Fortress)
-   **Public Schema Guard**: `REVOKE CREATE ON SCHEMA public FROM PUBLIC;` を実行。
-   **View Security**: `security_invoker = true` を設定。
-   **Search Path Defense (The Qualified Schema Mandate)**:
    -   **Law**: `SECURITY DEFINER` 関数には原則として `SET search_path = ''` (空) を設定し、検索パスへの依存を物理的に断ち切ってください。
    -   **Action**: 関数内では全てのテーブル参照を `public.users` のように**スキーマ完全修飾**で記述することを義務付けます。`SET search_path = public` は妥協であり、エイリアス攻撃のリスクを残します。

### Rule 8.2: The Audit Log Mandate / WORM
-   DB変更操作は `audit_logs` に記録し、テーブルは **Append-Only (追記のみ)** としてRLSで改竄を防止します。

### Rule 8.3: The Comprehensive RLS Audit
-   **Cascading Verification**: 重要テーブル（ナビゲーション、設定等）のRLS変更時は、**匿名ユーザー（ログイン前）** でのアクセス確認を義務付けます。
-   **Monthly Audit Mandate**: 月次でRLSポリシーの完全監査を実施すること。監査チェックリスト:
    - [ ] 全RLS有効テーブルでSELECT/INSERT/UPDATE/DELETEの各アクションにポリシーが存在するか
    - [ ] 管理者アクセス（`role IN ('admin', 'super_admin')`）が網羅的に設定されているか（管理者もロックアウトされていないか）
    - [ ] 一般ユーザーは自分のデータのみ閲覧・操作可能か
    - [ ] `(select auth.uid())` でスカラーサブクエリとしてラップされているか（Scalar Subquery Mandate）

### Rule 8.4: RLS Post-Change Verification Protocol
-   **Verification Scope**: RLSポリシー変更後は以下を必ず確認:
    1.  **Security Advisor**: 警告数がゼロであること。
    2.  **Functional Test**: 管理者、一般ユーザー、匿名ユーザーの各視点でデータアクセスを検証。
    3.  **Performance**: `EXPLAIN ANALYZE` でクエリプランに意図しないシーケンシャルスキャンがないこと。
-   **Critical Tables Checklist** (RLS変更後に必ず検証):
    - [ ] ナビゲーション系: `navigation_menus`, `navigation_items`
    - [ ] サイト設定系: `site_settings`, `system_settings`
    - [ ] 公開コンテンツ系: 店舗、投稿、レビュー等
    - [ ] マスタデータ系: エリア、カテゴリ等
-   **Pre-Deployment Smoke Test**:
    - [ ] トップページ (`/`) - ナビゲーション表示
    - [ ] ログインページ (`/login`) - フォーム表示
    - [ ] 一覧ページ - データ取得
-   **Emergency Recovery**: 障害発生時は影響テーブルに `FOR SELECT USING (true)` を即座に追加し、原因マイグレーションを特定して修正。
-   **Detection Symptoms (障害兆候)**:
    -   管理画面で「データがありません」だがDBには存在する。
    -   APIが403/404を返すがログには正常アクセスと記録される。
    -   本番のみデータが表示されない（開発環境との差異）。

---

## 9. ドメインデータモデリング (Domain Data Modeling)

### Rule 9.1: Universal Settings & Tenant-Aware Naming
-   **Strict Column Enforced**: アプリケーション設定値はRDBの正規化されたカラムとして定義。`jsonb` を設定ファイル代わりに使うことは型安全性の観点から禁止します。
-   **Tenant-Aware Naming (SaaS Readiness)**: 
    -   **Law**: 将来的なマルチテナント化（Whitelabel化）を見据え、内部リソース命名を区別してください。
    -   **Action**: 顧客（テナント）ごとの設定には `site_` や `account_` を、全テナント共通の基盤設定にのみ `system_` を使用します。これにより `tenant_id` 追加時の設計破綻を物理的に防ぎます。

### Rule 9.2: Static Page Ban (CMS Sovereignty)
-   利用規約やプライバシーポリシー等は **Headless CMS** で管理し、ハードコードされた静的ファイルを作成することを禁止します。

### Rule 9.3: Structural Integrity Protocols
-   **Structured Tagging**: 特徴データは `tags` テーブルで一元管理。
-   **Business Hours**: 営業時間は構造化データ(JSONB)とし、祝日設定を優先するロジックを標準化。
-   **Reputation System**: 評価スコアには単純平均ではなく **ベイジアン平均** を採用し、信頼性を担保。
-   **Geo-Centric**: 物理拠点には `latitude`/`longitude` を付与し、位置情報検索に対応。

### Rule 9.5: The Geolocation Data Strategy（位置情報データ戦略）
-   **Law**: 物理拠点を持つエンティティに座標情報を付与する際は、外部Geocoding API（従量課金）への依存を最小化し、**API不要の手段を優先**しなければなりません。
-   **Action**:
    1.  **API-Free First（推奨優先順位）**:
        -   **Pattern 1 (URL Parse)**: 地図サービスのURL（例: Google Maps URL）に埋め込まれた座標を正規表現で抽出する。API呼び出し不要・完全無料。
        -   **Pattern 2 (Manual Input)**: 地図サービス上で座標をコピーし、管理画面で直接入力する。
        -   **Pattern 3 (Geocoding API / Fallback)**: 上記で取得できない場合のみ、住所→座標変換APIをキャッシュ付きで使用する。**取得結果は必ずDBに保存**し、同一住所の再変換を防止すること（1回限りのAPI呼び出し）。
    2.  **Distance Calculation（距離計算基準）**: 2地点間の距離計算には**Haversine公式**（地球の曲率を考慮）を使用してください。
    3.  **Distance Display Format（距離表示形式）**:

        | 距離 | 表示形式 | 例 |
        |:-----|:---------|:---|
        | < 1km | メートル（100m単位） | `300m` |
        | 1-50km | キロメートル（0.1km単位） | `1.2km` |
        | > 50km | キロメートル（整数） | `52km` |

    4.  **Spatial Index**: 距離ベースの検索（「現在地からN km以内」）の実装を見越し、`latitude` / `longitude` への**GINインデックス**または**PostGIS拡張**の導入を推奨します。
-   **Rationale**: Geocoding APIは1,000回あたり数ドルの従量課金が発生します。API-Firstではなく「API-Free First」の姿勢で設計することにより、運用コストを劇的に削減しつつ、外部サービス障害の影響も最小化できます。

### Rule 9.4: The Time-Gated Content Schema Standard（時限公開コンテンツスキーマ標準）
-   **Law**: 公開予約機能を持つコンテンツテーブルには、`published_at` と `status` の組み合わせによる**時限公開スキーマ**を標準実装しなければなりません。
-   **Action**:
    1.  **Schema Standard**: 以下のカラムを定義してください：
        -   `status` (text): `'public'`, `'private'`, `'draft'`, `'archived'` 等の公開状態。
        -   `published_at` (timestamptz, nullable): 公開予定日時。`NULL` は「即時公開」を意味します。
    2.  **Query Condition (AND Conjunction)**: 公開コンテンツ取得クエリでは、以下の2条件を必ず**AND結合**してください。どちらか一方だけでは、非公開コンテンツの漏洩や公開予約の無効化を招きます。
        ```sql
        WHERE status = 'public'
          AND (published_at IS NULL OR published_at <= NOW())
        ```
    3.  **Indexing**: `published_at` は範囲検索で頻繁に使用されるため、インデックスの作成を推奨します。
-   **Rationale**: `status = 'public'` のみでのフィルタリングは、公開予約日前のコンテンツを漏洩させます。`published_at` のみでのフィルタリングは、下書き状態のコンテンツを公開します。両方のAND結合によってのみ、正確な公開制御が実現します。

---

## 10. 全球相互運用性 (Universal Portability)
-   **Ecosystem Portability**: 本プロジェクトのデータは、将来的に他システムや公的機関と連携される「デジタル資産」です。業界標準のスキーマ、メタデータ（Origin, Expiry）を採用し、エコシステム全体で通用する設計を維持してください。

---

## 11. バックエンド・ガバナンス (Backend Governance)

### Rule 11.1: The Data Residency Protocol (Rule 26.1)
-   **Law**: 特定の個人情報（PII）や法的文書は、準拠法（GDPR/APPI等）に基づき、特定のリージョン（例: 日本国内）に物理的に存在することを保証しなければならない場合があります。
-   **Action**: ストレージバケットやDBインスタンスのリージョン設計時に、将来の「データローカライゼーション要件」を考慮した構成（Multi-region Read/Local Write）を検討し、文書化してください。

### Rule 11.2: The Audit Bypass Anti-Pattern (Server Action Mandate)
-   **Law**: クライアントサイドからの直接書き込みは、サーバーサイドの監査ログ（Audit Logs）や複雑なバリデーションをバイパスする「ガバナンスの穴」となります。
-   **Action**: 
    1. **Surgical Write**: 原則として書き込みは **Server Actions** に集約し、その内部で `recordAuditLog` を呼び出すことを義務付けます。
    2. **Exception Recognition**: 現実的な制約でクライアントから INSERT する場合は、DBトリガー (`AFTER INSERT`) に `recordAuditLog` 相当のロジックを実装し、物理的にバイパスを不可能にしてください。

### Rule 11.3: The RLS Best Practices Protocol (ポリシー衛生)
-   **Law 1: No Redundant Admin Policy**: `service_role` キーはRLSを完全にバイパスします。したがって、`TO service_role` のポリシーは**意味がなく冗長**です。管理者アクセスはアプリケーション層（`is_admin()` ヘルパー）で制御してください。
-   **Law 2: One Policy Per Action**: 同一テーブル、同一アクション（例: `SELECT`）に対して複数の `PERMISSIVE` ポリシーが存在する場合、PostgreSQLはそれらを `OR` で結合します。これは意図しないアクセス許可を生みます。**1テーブル、1アクションにつき、原則1ポリシー**を徹底してください。
-   **Law 3: No WITH CHECK (true)**: `WITH CHECK (true)` は「誰でも書き込み可能」を意味します。本番テーブルへの適用は厳禁です。必ず `auth.uid()` 等による所有権チェックか、管理者ロールチェックを含めてください。

### Rule 11.4: The Poison Row Prevention Protocol (型崩壊防止)
-   **Context**: 自動生成型 (`database.types.ts`) を拡張する際に、交差型 (`&`) で `Insert` / `Update` を `never` に設定すると、型推論が壊れ（Type Collapse）、正当なINSERT/UPDATE操作が型エラーで拒否されるようになります。
-   **Law**: 拡張型定義において、自動生成型の `Insert` / `Update` サブタイプを `never` で上書きすることを禁止します。
-   **Action**:
    1.  **Type Alias**: 拡張型は `interface` ではなく **`type` エイリアス** を使用してください（Mapped Typeとの互換性）。
    2.  **Intersection Safety**: 交差型で拡張する場合は、`Row` のみを対象にし、`Insert` / `Update` は元の型をそのまま継承させてください。
    3.  **Validation**: 拡張型を定義した後、必ず `supabase.from('table').insert({...})` がコンパイルを通ることを確認してください。

### Rule 11.5: The Idempotent Migration Protocol (冪等マイグレーション)
-   **Context**: マイグレーションは「クリーンルーム」（CIの新規DB）と「ダーティルーム」（既にデータが存在する本番DB）の両方で実行されます。両環境で成功することを保証する設計が必要です。
-   **Law**: マイグレーションファイルは、何度実行しても同じ結果になる**冪等性（Idempotency）**を持たなければなりません。
-   **Action**:
    -   **Functions**: `CREATE FUNCTION` ではなく `CREATE OR REPLACE FUNCTION` を使用してください。
    -   **Policies**: `CREATE POLICY` の前に `DROP POLICY IF EXISTS` を記述してください。
    -   **DML**: `INSERT` には `ON CONFLICT ... DO NOTHING` または `DO UPDATE` を付与し、既存データとの衝突を防いでください。
    -   **Tables/Indexes**: `IF NOT EXISTS` を必ず付与してください。
-   **Rationale**: CI/CDパイプラインでの再実行やロールバック後の再適用に対応するため。冪等でないマイグレーションは「爆弾」です。

### Rule 11.6: The Admin/System Write Service Role Mandate (管理者書き込みのService Role義務)
-   **Law**: 管理者（Admin）の書き込み操作（Create/Update/Delete）は、`anon` キー + Cookie セッション（`createClient()`）ではなく、**`serviceRoleKey`（`createAdminClient()`）を使用**しなければなりません。
-   **Reason**:
    1.  Server Action経由でSupabaseを呼び出す際、セッション情報が正しく渡されない場合がある。
    2.  RLSが `UPDATE` を拒否しても**エラーを返さず0行更新（サイレント失敗）**になる。
    3.  管理者操作は業務都合上RLSの制約を超える必要があるケースが多い。
-   **Action**:
    1.  **Admin Write**: 管理画面からの全書き込み操作は `createAdminClient()` を使用してください。
    2.  **System Job**: Cron、Webhook等のバックグラウンドジョブも同様に `createAdminClient()` を使用してください（ユーザーセッションが存在しないため）。
    3.  **Read is OK**: 管理者の読み取り操作は `createClient()` でも問題ありませんが、一貫性のため `createAdminClient()` の使用を推奨します。

### Rule 11.7: The Silent RLS Failure Detection Protocol (RLSサイレント失敗検知)
-   **Law**: SupabaseのRLSポリシーにより操作が拒否された場合、PostgRESTは**エラーを返さずに「0行影響（affected rows = 0）」を返す**仕様です。これは「サイレント失敗」であり、最も検知困難なバグの原因です。
-   **Action**:
    1.  **Count Check**: UPDATE/DELETE操作後は、戻り値の `count` が `null` または `0` でないことを検証してください。`hasError: false` かつ `count: null` はRLS違反のシグナルです。
    2.  **Explicit Error**: `count === 0` の場合は、明示的なエラーを返すラッパー関数を実装してください（例: `throw new Error('RLS policy may have blocked this operation')`）。
    3.  **Logging**: サイレント失敗が疑われるケースではログに `{ operation, table, userId, affectedRows }` を記録し、後日の原因調査を可能にしてください。
-   **Diagnostic**: 「保存成功なのにリロードすると元に戻る」→ **RLSサイレント失敗を疑え**。

### Rule 11.8: The RPC Scope Limitation Protocol（RPCスコープ制限）
-   **Law**: DB側のRPC（PL/pgSQL関数）に複雑なビジネスロジック（条件分岐の連鎖、外部API呼び出しの模倣、複数エンティティにまたがるワークフロー）を押し込むことを**禁止**します。
-   **Action**:
    1.  **Atomic Operations Only**: RPCの用途は「アトミックなデータ操作」に限定してください。許可される用途: バルク更新（`UPDATE ... WHERE id = ANY(...)`）、システム権限チェック、集計クエリ、トランザクション内の複数テーブル同時操作。
    2.  **Application Layer Logic**: 条件分岐、ワークフロー制御、外部サービス連携、通知送信等のビジネスロジックは、アプリケーション層（Server Actions / TypeScript等）で記述してください。
    3.  **Debuggability**: PL/pgSQLは型安全性が低く、デバッグツールも限定的です。ロジックをアプリケーション層に保つことで、ブレークポイント設定・ログ出力・テスト記述が容易になります。
    4.  **DB Load Offloading**: 重い計算処理をDB側に押し込むと、DB接続プールを圧迫し、他のクエリの遅延を招きます。計算はアプリケーション層にオフロードしてください。
-   **Rationale**: RPCへのビジネスロジック集中は、デバッグ困難性・型安全性の欠如・DB負荷増大という三重のリスクを生みます。RPCは「DBが最も効率的に処理できる操作」に限定し、アプリケーション層との適切な責務分離を維持してください。

### Rule 11.9: The Ghost Migration Ban（ゴーストマイグレーション禁止）
-   **Law**: マイグレーションファイル化されていないDB操作（手動でのカラム追加・変更・削除、Dashboard上でのスキーマ変更等）を**「ゴーストマイグレーション」と定義し、厳禁**とします。
-   **Action**:
    1.  **Migration File Mandate**: すべてのスキーマ変更は、必ずマイグレーションツール（`supabase migration new` 等）を経由し、マイグレーションファイルとしてGitに保存されなければなりません。
    2.  **No Dashboard Edits**: DB管理画面（Supabase Dashboard、pgAdmin等）での直接的なスキーマ変更は、履歴追跡が不可能となるため禁止します。緊急対応であっても、事後に必ずマイグレーションファイルを作成してGitに反映してください。
    3.  **Schema Consistency Protocol**: ローカル環境のスキーマがマイグレーションファイルと乖離（汚染）した場合は、DB再構築（`supabase db reset` 等）を躊躇してはなりません。常にマイグレーションファイルをSource of Truth（正）として扱い、ローカルDBを従とします。
    4.  **Verification**: マイグレーション適用後は、ローカルスキーマとリモートスキーマの差分がゼロであることを確認してください。差分がある場合はゴーストマイグレーションの存在を疑います。
-   **Rationale**: マイグレーションファイルに記録されない変更は、チーム間での再現不能、CI/CD障害、本番環境との不整合を引き起こします。「全ての変更は記録される」という原則こそが、スキーマの信頼性を担保する唯一の方法です。

## 12. マイグレーションと特権操作 (Migrations & Privileged Operations)

### Rule 12.1: The Admin Write Service Role Protocol（管理者書き込みのService Role使用義務）
-   **Law**: 管理画面やバックグラウンドジョブからのDB書き込み操作は、ユーザー認証セッションに依存しない**特権クライアント（Service Role Key）**を使用しなければなりません。通常クライアント（ユーザーセッション経由）での管理者書き込みは、RLSポリシーによりサイレントに拒否される危険があります。
-   **Action**:
    1.  **Admin Write**: 管理画面からの全書き込み操作（INSERT/UPDATE/DELETE）は、RLSをバイパス可能な特権クライアントを使用してください。
    2.  **System Job**: Cron、Webhook、バッチ処理等のバックグラウンドジョブも同様に特権クライアントを使用してください（ユーザーセッションが存在しないため）。
    3.  **Principle of Least Privilege**: 特権クライアントの使用はサーバーサイドに限定し、クライアントサイドコードでService Role Keyを使用することは**厳禁**です。
    4.  **Audit Trail**: 特権クライアント経由の操作は、RLSをバイパスしているため、アプリケーション層で明示的に監査ログを記録してください。
-   **Rationale**: Server Action等のサーバー実行コードでも、フレームワークのセッション管理の仕組みによっては認証情報が正しく渡らず、RLSが意図せず操作を拒否するケースがあります。管理者操作が「エラーなし・影響0行」で終了する「サイレント失敗」は、最も発見困難なバグです。

### Rule 12.2: The Idempotent Migration Protocol（冪等マイグレーション義務）
-   **Law**: データベースマイグレーションファイルは、**何度実行しても同じ結果になる（冪等性）**ことを保証しなければなりません。CI環境、プレビュー環境、本番環境でマイグレーションが部分実行される可能性を常に想定してください。
-   **Action**:
    1.  **CREATE OR REPLACE**: 関数（Function）やビュー（View）の作成・更新には `CREATE OR REPLACE` を使用し、`ALTER` ではなく宣言的な定義を推奨してください。
    2.  **IF NOT EXISTS**: テーブルやインデックスの作成には `CREATE TABLE IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS` を使用してください。
    3.  **DROP IF EXISTS + CREATE**: ポリシーやトリガーなど `CREATE OR REPLACE` が使用できないオブジェクトは、`DROP ... IF EXISTS` → `CREATE` のパターンを使用してください。
    4.  **Defensive DML**: シードデータの挿入には `INSERT ... ON CONFLICT DO NOTHING`（または `DO UPDATE`）を使用し、重複挿入エラーを防いでください。
-   **Rationale**: CI環境は空のDBでマイグレーションを適用するため常に冪等ですが、プレビュー環境や手動復旧時には過去のマイグレーションが部分的に適用されている場合があります。冪等でないマイグレーションはこれらの環境でデプロイ障害を引き起こします。

### Rule 12.3: The Anti-Permissive Policy Duplication Mandate（冗長ポリシー禁止義務）
-   **Law**: RLS（Row Level Security）のポリシー設計において、同一ロール・同一アクションに対する**冗長なPermissiveポリシーの作成を禁止**します。特に `service_role` はRLSをバイパスするため、管理者用の別途ポリシーは不要です。
-   **Action**:
    1.  **One Policy Per Role-Action**: 同一テーブルに対し、同一ロール（`authenticated`, `anon` 等）の同一アクション（`SELECT`, `INSERT` 等）で複数の Permissive ポリシーを作成しないでください。複数条件がある場合は `OR` で1つのポリシーにまとめます。
    2.  **No service_role Policy**: `service_role` はRLSを完全にバイパスするため、`service_role` 用のRLSポリシーを作成することは冗長であり禁止します。
    3.  **Policy Audit**: 既存ポリシーの追加・変更時は、同一テーブルの全ポリシーを一覧し、論理的な重複がないか確認してください。
-   **Rationale**: PostgreSQL の Permissive ポリシーは `OR` で結合されるため、意図せず広い範囲を許可してしまうリスクがあります。1ロール1アクション1ポリシーの原則により、権限の意図を明確にし、セキュリティホールを防ぎます。

### Rule 12.3.1: The RLS Auth Function InitPlan Optimization（RLS認証関数InitPlan最適化）
-   **Law**: RLSポリシー内で `auth.uid()`, `auth.role()`, `current_setting()` 等の認証関数を使用する際、必ず **`(select ...)`でラップ** し、各行での再評価を防がなければなりません。
-   **Action**:
    1.  **Subquery Wrap**: `USING (user_id = auth.uid())` ではなく `USING (user_id = (select auth.uid()))` と記述してください。
    2.  **All Auth Functions**: `auth.uid()`, `auth.role()`, `auth.jwt()`, `current_setting()` 等、セッション情報を返す全ての関数に適用してください。
    3.  **EXISTS内も同様**: `EXISTS (SELECT 1 FROM ... WHERE ... = auth.uid())` も、内部の `auth.uid()` を `(select auth.uid())` にラップしてください。
-   **Rationale**: ラップなしの場合、PostgreSQLは各行のスキャンごとにこれらの関数を再評価します（Volatile扱い）。`(select ...)`でラップすることで、PostgreSQLのオプティマイザは結果を**InitPlan（事前計算）**として1回だけ評価し、大規模テーブルでの劇的なパフォーマンス改善を実現します。
-   **Anti-Pattern**:
    ```sql
    -- ❌ 禁止: 各行で auth.uid() が再評価される
    USING (user_id = auth.uid())
    ```
-   **Correct Pattern**:
    ```sql
    -- ✅ 正解: InitPlanにより1回だけ評価
    USING (user_id = (select auth.uid()))
    ```

### Rule 12.4: The Type Extension Safety Protocol（型拡張安全プロトコル）
-   **Law**: データベースSDKやORM等が自動生成する型定義を、アプリケーション固有の型で拡張する際には、型の安全性を損なわない手法を用いなければなりません。
-   **Action**:
    1.  **No `never` in Type Extensions**: 自動生成型のプロパティを `never` で上書きする型拡張を禁止します。`never` は「到達不能」を意味するため、実行時にはプロパティが存在するにも関わらず型レベルではアクセス不能となる「Poison Row」を引き起こします。
    2.  **Type Alias over Interface**: 自動生成型の拡張には `interface extends` よりも `type` エイリアスと交差型（`&`）を優先してください。Interface の `extends` は宣言マージ（Declaration Merging）による意図しない汚染のリスクがあります。
    3.  **Simple Intersection over Omit**: `Omit<GeneratedType, 'key1' | 'key2' | ...>` の多用は型の可読性を著しく低下させます。可能な限り単純な交差型で拡張し、`Omit` はプロパティの型を変更する場合にのみ使用してください。
    4.  **Generated Type Sovereignty**: 自動生成型のファイル自体を手動で編集することは厳に禁止します。拡張は常に別ファイルで行ってください。
-   **Rationale**: 自動生成型は「DBスキーマの真実」を反映する重要な資産です。不適切な拡張はこの真実を歪め、型定義と実データの乖離を引き起こします。

### Rule 12.5: The Migration System Schema Exclusion Protocol（マイグレーション・システムスキーマ除外プロトコル）
-   **Law**: データベースマイグレーションにおいて、関数のセキュリティ設定（`search_path`、`SECURITY DEFINER/INVOKER`等）を一括変更するスクリプトを作成する際、**マネージドサービスが管理するシステムスキーマの関数は除外リストに含める**ことを義務付けます。
-   **Action**:
    1.  **Exclusion List**: `auth`, `storage`, `realtime`, `supabase_functions`, `graphql`, `graphql_public`, `pgsodium`, `vault`, `extensions` などのシステムスキーマの関数は、一括変更の対象から明示的に除外してください。
    2.  **Schema Filter**: マイグレーションスクリプトの `WHERE` 句で `n.nspname NOT IN ('auth', 'storage', ...)` を使用し、システムスキーマの関数への干渉を物理的に防止してください。
    3.  **Dry Run**: 一括変更マイグレーションを適用する前に、対象となる関数の一覧をプレビュー（`SELECT` のみ実行）し、システム関数が含まれていないことを確認してください。
-   **Rationale**: マネージドサービスのシステム関数（認証、ストレージ管理等）の `search_path` やセキュリティ設定を変更すると、サービスの基盤機能が破壊される可能性があります。これは即座にサービス全停止につながる致命的な障害です。

### Rule 12.6: The RLS InitPlan Optimization Protocol（RLS InitPlan最適化義務）
-   **Law**: RLS（Row Level Security）ポリシー内での `auth.uid()`、`auth.role()` 等のセッション関数呼び出しは、**`(SELECT auth.uid())` のようにサブクエリ（Sub-Select）として記述**しなければなりません。
-   **Action**:
    1.  **Sub-Select Wrapping**: RLSポリシーの `USING` 句や `WITH CHECK` 句で `auth.uid()` を使用する場合、必ず `(SELECT auth.uid())` の形式にしてください。これにより、PostgreSQLのクエリプランナが関数を一度だけ評価してその結果をInitPlanとしてキャッシュし、行ごとの再評価を防止します。
    2.  **All Auth Functions**: `auth.uid()` だけでなく、`auth.role()`、`auth.jwt()` 等の全てのセッション関数に同じパターンを適用してください。
    3.  **Linter Integration**: Supabaseのセキュリティリンター等が `auth_rls_initplan` 警告を出す場合は、即座に修正してください。
    4.  **Performance Impact**: 大規模テーブル（数万行以上）では、このパターンの適用で数十倍のパフォーマンス差が生じる場合があります。
-   **Rationale**: RLSポリシー内の関数が行ごとに再評価されると、テーブルスキャンのたびにO(N)回の関数呼び出しが発生します。サブクエリ化によりO(1)に削減され、大規模テーブルでのクエリパフォーマンスが劇的に向上します。

### Rule 12.7: The Client Identity Audit Protocol（クライアントIDコンテキスト監査義務）
-   **Law**: RLSポリシーの最適化（統合・削除）を行う前に、対象データにアクセスする**全ての経路**（Server Action、API Route、SSR、管理画面等）が**どのIDENTITY**（`service_role` / User JWT / Anonymous）を使用しているかを**網羅的に監査**しなければなりません。
-   **Action**:
    1.  **Access Path Inventory**: 対象テーブルにアクセスする全てのコードパス（Service層、Gateway層、Server Action等）をリストアップし、それぞれが使用するクライアント初期化関数（`createClient`, `createAdminClient` 等）を特定してください。
    2.  **No Blind Optimization**: 「`service_role` で十分だから」という理由でユーザーJWT向けのポリシーを削除しないでください。Server Action等がユーザーJWTを使用している場合、そのポリシーの削除は正規アクセスのサイレントな遮断を引き起こします。
    3.  **Identity Matrix**: 複雑なテーブルに対しては、「テーブル × 操作 × 使用IDENTITY」のマトリクスを作成し、全てのアクセスパターンが少なくとも1つのRLSポリシーでカバーされていることを確認してください。
    4.  **Post-Change Verification**: ポリシーを変更・削除した後は、影響を受ける全てのUIフロー（管理画面の編集・保存、ユーザー向けの閲覧等）を実際に操作して動作を確認してください。
-   **Rationale**: RLSポリシーの「最適化」による不用意な削除は、セキュリティホールではなく「正規アクセスの不可視化」を招きます。特に管理画面がServer Action（ユーザーJWTコンテキスト）を使用している場合、service_roleで十分だと思ってJWT向けポリシーを削除すると、管理者のCRUD操作がサイレントに拒否されます。

### Rule 2.8: The Idempotent Migration Protocol（冪等マイグレーション義務）
-   **Law**: マイグレーションファイルは、何度実行しても同じ結果を生む**冪等な構造**で記述しなければなりません。DML（データ操作）を含む場合は、本番データとの衝突を想定した防衛的コードで記述してください。
-   **Action**:
    1.  **DDL Idempotency**: `CREATE TABLE` は `IF NOT EXISTS`、`DROP TABLE` は `IF EXISTS`、`ALTER TABLE ADD COLUMN` は `IF NOT EXISTS`（PostgreSQL 9.6+）を必ず付与してください。
    2.  **DML Idempotency**: `INSERT` は `ON CONFLICT DO NOTHING` または `ON CONFLICT DO UPDATE` を使用し、既存データとの重複時にエラーにならないようにしてください。
    3.  **Function/Trigger Idempotency**: `CREATE OR REPLACE FUNCTION` を使用し、関数の再作成が安全に行えるようにしてください。トリガーは `DROP TRIGGER IF EXISTS ... ; CREATE TRIGGER ...` のパターンで記述してください。
    4.  **RLS Policy Idempotency**: ポリシーの作成前に `DROP POLICY IF EXISTS "policy_name" ON table_name;` を実行し、既存ポリシーとの衝突を防止してください。
-   **Rationale**: マイグレーションの非冪等性は、ステージング環境と本番環境の差異、マイグレーションの再実行、ブランチ間の競合時に「一度通ったはずのマイグレーションが壊れる」致命的な障害を引き起こします。冪等性は、安全なデプロイと環境再現性の基盤です。

### Rule 2.9: The Read-Write Privilege Symmetry（読み書き権限の対称性）
-   **Law**: 管理画面等において、書き込み（Mutation）が特権クライアント（`service_role` 等）で実行される場合、**読み込み（Query for Edit Form）も同等の可視性を保証**しなければなりません。書き込みと読み込みで異なる権限レベルのクライアントを使用すると、「保存は成功するがリロードすると元に戻る」という不透明なバグが発生します。
-   **Action**:
    1.  **Privilege Parity Check**: 書き込みに `createAdminClient()`（RLSバイパス）を使用している場合、対応する「編集のための取得」も同等の権限で実行されるか確認してください。読み込みが `anon` や制限された `authenticated` 権限で行われると、RLSにより一部のデータがフィルタされ、フォームに古いデータや空データが流し込まれます。
    2.  **Select Spec Synchronization**: DTOで使用する Select Specification が、保存対象の全カラムを包含しているか確認してください。片方にだけカラムを追加すると、「保存はされるが編集画面に表示されない」片肺状態になります。
    3.  **Admin Gateway Awareness**: 管理目的が明示的な関数（例: `getAdminStoreById`）では、必要に応じて特権クライアントを使用するか、RLSポリシーを管理ロールに対して完全に開放してください。
    4.  **Post-Update Verification**: 重要度の高いミューテーション（画像の並び替え、ステータス変更等）では、更新直後に同じIDで `select` を実行し、現在値をログで確認する「Verification Fetch」パターンの適用を検討してください。
-   **Rationale**: 特権クライアントによる書き込みは RLS をバイパスしてデータを正しく保存しますが、編集画面の再読み込み時に非特権クライアントが使用されると、RLS の `SELECT` ポリシーにより一部のカラムやレコードが除外されます。結果として、ユーザーは「保存したのに反映されない」と感じ、同じ操作を繰り返すことでデータの不整合がさらに拡大する悪循環に陥ります。

### Rule 2.10: The RLS Policy Consolidation Mandate（RLSポリシー統合義務）
-   **Law**: 同一テーブル・同一操作（SELECT, INSERT, UPDATE, DELETE）に対して、複数の `PERMISSIVE` ポリシーが定義されている場合、評価オーバーヘッドを削減するため、可能な限り**単一のポリシーにOR条件で統合**しなければなりません。
-   **Action**:
    1.  **Consolidation by Operation**: `anon` 向けと `authenticated` 向けに別々の `SELECT` ポリシーを定義するのではなく、`USING (true)` や `USING (auth.role() IN ('anon', 'authenticated'))` のように単一ポリシーに統合してください。PostgreSQLは全ての `PERMISSIVE` ポリシーをOR結合で評価するため、個別ポリシーの分割は評価回数を不必要に増加させます。
    2.  **Service Role Redundancy Elimination**: `service_role` はRLSを完全にバイパスするため、`service_role` 向けの明示的なポリシーは冗長です。`service_role` のみを対象としたポリシーが存在する場合は削除してください。
    3.  **RESTRICTIVE Policy Awareness**: `RESTRICTIVE` ポリシーは全ての `PERMISSIVE` ポリシーの**AND条件**として評価されるため、統合対象は `PERMISSIVE` ポリシーのみです。`RESTRICTIVE` ポリシーの統合は副作用を引き起こす可能性があります。
    4.  **New Table Checklist**: 新規テーブル作成時のRLSポリシー設計では、「操作ごとに最小数のポリシー」を設計原則としてください。同一操作に2つ以上のポリシーを作成する場合は、統合不可能な理由を明示的にコメントしてください。
-   **Rationale**: PostgreSQLは同一操作に対する全ての `PERMISSIVE` ポリシーをOR結合で評価するため、機能的に同等の条件を複数のポリシーに分割しても結果は変わりませんが、評価のオーバーヘッドが増加します。特に大量のレコードを持つテーブルでは、不要なポリシーの分割がクエリパフォーマンスに直接影響します。

### Rule 2.11: The Orphan File Defense Protocol（孤立ファイル防衛）
-   **Law**: データベースレコードの削除時に、関連するストレージ上のファイルを放置する（Orphan Files）ことを禁止します。孤立ファイルはストレージコストを継続的に増大させ、意図しない情報残存のリスクを生みます。
-   **Action**:
    1.  **Cascade Deletion**: `DELETE` トリガー、またはアプリケーションのミューテーションロジック内で、DBレコード削除時に関連するストレージファイルも**非同期で削除**する処理を組み込んでください。同期的な削除はレスポンスタイムに影響するため、非同期ジョブ（Queue/Worker）を推奨します。
    2.  **Batch Cleanup**: 定期的（例: 週次）にバッチジョブを実行し、DBに参照が存在しないストレージファイル（孤立ファイル）を検出・削除するスイーパーを設置してください。
    3.  **Soft Delete Awareness**: 論理削除（`deleted_at`）を採用している場合、ファイル削除はレコードの物理削除時（またはアーカイブ移行時）まで遅延させてください。論理削除時点でファイルを消すと、復元時にファイルが失われます。
-   **Rationale**: レコードのみ削除してファイルを放置する運用は、ストレージコストの「サイレントリーク」を引き起こします。特にUGC（ユーザー生成コンテンツ）が多いサービスでは、月単位で数十GBの孤立ファイルが蓄積し、FinOps上の重大な損失となります。

### Rule 2.12: The Safety Valve Protocol（安全弁カラム義務）
-   **Law**: 主要なエンティティテーブル（ユーザー、コンテンツ、商品、店舗等）には、スキーマ変更を必要とせずにイレギュラー情報を記録できる**自由記述カラム**（`notes`, `remarks`, `internal_memo` 等）を必ず1つ以上設置しなければなりません。
-   **Action**:
    1.  **Escape Hatch**: 現実の運用では、厳格なスキーマだけでは表現しきれない例外（「冬季閉鎖」「要電話確認」「特別対応あり」等）が頻繁に発生します。自由記述カラムは、スキーマ変更を待たずにこれらの情報を記録する「安全弁（Escape Hatch）」として機能します。
    2.  **Type**: `TEXT` 型（またはMarkdown対応が必要な場合は `TEXT`）を推奨します。`VARCHAR(n)` の文字数制限は運用時の障害要因となるため、特段の理由がない限り避けてください。
    3.  **Nullable**: 自由記述カラムは `NULL` を許容してください。全レコードに記述が必要な性質のものではありません。
    4.  **No Business Logic**: 自由記述カラムの値にビジネスロジック（条件分岐、フィルタリング）を依存させることを禁止します。ロジックに必要な情報は正規化カラムとして昇格させてください。
-   **Rationale**: スキーマ変更にはマイグレーション・デプロイ・テストのサイクルが必要であり、即座に対応できません。安全弁カラムの設置により、「今すぐ記録する必要がある」情報をロスなく保存でき、運用の柔軟性と開発速度の両立を実現します。

### Rule 2.13: The Time-Series Partitioning & Retention Protocol（時系列パーティション＆保持期間戦略）
-   **Law**: ログデータ（`audit_logs`, `access_logs`）やトランザクション履歴（`point_transactions` 等）など、時系列で肥大化するテーブルには、`created_at` をキーとした**Range Partitioning**を設計しなければなりません。
-   **Action**:
    1.  **Range Partitioning**: 時系列テーブルは `pg_partman` 等を使用し、月次または四半期でパーティションを自動作成してください。単一テーブルのレコード数が1,000万件（10M）を超える予測で導入を検討します。
    2.  **Retention Policy**: 古いパーティション（例: 2年以上前）は自動的に**Detached Partition**とし、アクティブなクエリ対象から除外してください。Detach後はCold Storageへの移動またはObject Storageへのエクスポートを計画します。
    3.  **No Premature Partitioning**: データが少ない開発フェーズでのパーティション導入は過剰設計です。閾値（10M件）に達する前に設計を完了し、達した時点で適用する「Ready-to-Fire」戦略を採用してください。
-   **Rationale**: パーティションなしで肥大化したテーブルは、インデックスサイズの増大、バキューム時間の延長、バックアップ時間の増加を引き起こします。時系列パーティションにより、古いデータの運用負荷をゼロに近づけつつ、法的保管義務への対応も可能になります。

### Rule 2.14: The Cold Data Offloading Protocol（アーカイブ戦略）
-   **Law**: 「1年以上アクセスがない」「法的保管義務があるが参照頻度が低い」データは、アクティブなDBから切り離し、**Archived Tables**またはObject Storage（CSV/Parquet）へ退避させなければなりません。
-   **Action**:
    1.  **Archived Tables**: アーカイブ用スキーマ（例: `archives`）を用意し、古いデータを移動してください（例: `archives.old_audit_logs`）。アプリケーションの通常クエリはこのスキーマを参照しません。
    2.  **Object Storage Export**: 大量の古いデータは、CSVまたはParquet形式でObject Storage（S3/R2/GCS等）にエクスポートしてください。分析が必要な場合はData Warehouse（BigQuery等）から参照します。
    3.  **Transparent Migration**: データの退避は、アプリケーションの動作に一切影響を与えない形で実行してください。アーカイブ対象のレコードがAPI応答に含まれないことを確認します。
    4.  **Compliance**: 法的保管義務（税法：7年、労働法：3年等）のあるデータは、保管期間が経過するまで物理削除してはなりません。アーカイブ先で保管期間を管理してください。
-   **Rationale**: アクティブDBに古いデータを残し続けると、インデックスサイズの膨張、クエリパフォーマンスの低下、バックアップ時間の増加を招きます。データの「温度」で保管先を分けることにより、アクティブデータのパフォーマンスとコスト効率を最大化します。

### Rule 2.15: The RLS Inheritance Protocol（権限継承・Chain of Trust）
-   **Law**: 子テーブル・孫テーブル（例: 医療記録、コメント、添付ファイル等）のアクセス権限は、**単独で定義せず**、必ず親テーブル（例: ペット、投稿、プロジェクト等）の所有権や参加状況を `EXISTS` サブクエリで参照して決定しなければなりません。
-   **Action**:
    1.  **Parent Ownership Check**: 子テーブルのRLSポリシーでは、直接 `auth.uid() = user_id` で認証するのではなく、親テーブルの所有権を `EXISTS (SELECT 1 FROM parent_table WHERE id = child_table.parent_id AND user_id = (select auth.uid()))` で検証してください。
    2.  **Chain of Trust**: テーブル階層が3段階以上（祖父→親→子）になる場合も、常に最上位の所有権まで遡って検証してください。中間テーブルだけの検証はセキュリティホールを生みます。
    3.  **SECURITY DEFINER for Cross-Table**: 権限チェックで他テーブル（`profiles` 等）を参照する必要がある場合は、`SECURITY DEFINER` 関数内でラップし、`search_path` を固定（`SET search_path = public, pg_temp`）してください。
    4.  **No Redundant Columns**: 子テーブルに `user_id` を重複して持たせることで権限チェックを「簡略化」するアプローチは、データ不整合の温床となるため非推奨です。権限は常に関係（Relation）で導出してください。
-   **Rationale**: 子テーブルごとに独立した権限ロジックを定義すると、親テーブルの権限変更時に子テーブルの更新漏れが発生し、セキュリティホールの原因となります。親テーブルの所有権を信頼の連鎖（Chain of Trust）として継承することで、権限ロジックの一元化と不整合の排除を実現します。

### Rule 2.16: The Brittle Table Reference Prohibition（動的テーブル参照禁止）
-   **Law**: SQL関数（`CREATE FUNCTION`）やRPC内で、テーブル名を動的な文字列として結合（`EXECUTE 'SELECT * FROM ' || table_name`）することを**禁止**します。
-   **Action**:
    1.  **Static References Only**: すべてのSQL関数内のテーブル参照は、静的なSQL文として記述してください。コンパイル時（またはマイグレーション適用時）に依存関係が解決されなければなりません。
    2.  **No Dynamic EXECUTE**: `EXECUTE format('SELECT * FROM %I', variable)` のようなパターンは、テーブル名のタイポや存在しないテーブルへの参照をランタイムまで検出できないため禁止します。
    3.  **Schema Change Safety**: 静的なテーブル参照により、テーブルのリネームや削除時に依存関数がマイグレーション時点でエラーとなり、問題を早期検出できます。
-   **Rationale**: 動的テーブル参照はSQLインジェクションの温床となり、スキーマ変更時の影響範囲追跡も不可能にします。静的参照を義務付けることで、コンパイル時安全性と保守性を確保します。

### Rule 2.17.1: The Data Quality Management Framework（データ品質管理フレームワーク）
-   **Law**: 蓄積されるデータは「副産物」ではなく、独立した**収益資産**として設計・管理しなければなりません。データ品質を以下の6次元で体系的に計測・管理し、品質劣化を早期に検知する義務があります。
-   **DQ Framework**:

    | 品質次元 | 定義 | 計測方法 | 目標 |
    |:---------|:-----|:---------|:-----|
    | **正確性 (Accuracy)** | データが現実を正しく反映しているか | サンプリング検証 | ≥ 95% |
    | **完全性 (Completeness)** | 必須フィールドが埋まっているか | NULL率計測 | ≥ 90% |
    | **一貫性 (Consistency)** | 同一エンティティのデータが矛盾していないか | Cross-table検証 | ≥ 99% |
    | **鮮度 (Freshness)** | データが最新であるか | `updated_at` 経過日数 | ≤ 30日 |
    | **一意性 (Uniqueness)** | 重複データが存在しないか | 重複検出クエリ | 重複率 ≤ 1% |
    | **適合性 (Conformity)** | データ型・フォーマットが規定に準拠しているか | Schema Validation | 100% |

-   **Action**:
    1.  **Automated DQ Checks**: 月次のバッチジョブ（`pg_cron` またはクラウドスケジューラ）で上記6指標を自動計測し、管理ダッシュボードに表示してください。
    2.  **Asset Registry**: 主要データ資産を台帳化し、各資産の「所有者」「品質責任者」「収益可能性」を明記してください。
    3.  **Cleansing Mandate**: データはクレンジング済みの状態が常に維持されること。ゴミデータ（未検証の入力、重複レコード、型不正）の放置を禁止します。
    4.  **Alert Threshold**: いずれかの品質次元が目標値を下回った場合、アラートを発報し、30日以内に是正措置を完了してください。
-   **Rationale**: データ品質を定量的に管理しないと、「クリーンに見えるが実は矛盾だらけ」のデータが蓄積し、API外販・AI学習・分析の全てに悪影響を及ぼします。6次元フレームワークにより、品質劣化を構造的に防止します。

---

## 13. Edge Functions設計戦略 (Edge Functions Design Strategy)

### Rule 13.1: The Edge Functions Architecture Protocol
-   **Law**: Supabase Edge Functions（Deno Deploy基盤）は、**短命・ステートレス・単一責務**の原則で設計しなければなりません。汎用的なバックエンドサーバーの代替として使用することを禁止します。
-   **Action**:
    1.  **Single Responsibility**: 1つのEdge Functionは1つのタスク（Webhook受信、外部API呼び出し、PDF生成等）のみを担当してください。複数の責務を1関数に詰め込むモノリシック設計は禁止です。
    2.  **Stateless Execution**: Edge Functions間で状態を共有する設計は禁止です。状態はDB（PostgreSQL）またはキャッシュ（Redis等）に永続化してください。
    3.  **Timeout Awareness**: Edge Functionsには**実行時間制限**（デフォルト150秒、Proプランで最大400秒）があります。長時間処理（大量データの一括処理、動画エンコーディング等）はEdge Functionsに適しません。バッチ処理はDatabaseの `pg_cron` + PL/pgSQL、または外部ワーカーに委譲してください。
    4.  **Cold Start Minimization**: import文を最小限に抑え、不要な依存パッケージを排除してください。Denoの`esm.sh`経由のインポートは初回ロード時にネットワークI/Oが発生します。

### Rule 13.2: The Edge Functions Security Mandate
-   **Law**: Edge Functionsのセキュリティは、関数レベル・ネットワークレベル・シークレット管理の3層で担保しなければなりません。
-   **Action**:
    1.  **JWT Verification**: 外部から直接呼び出されるEdge Functionsでは、リクエストの `Authorization` ヘッダーから JWT を検証し、`supabase.auth.getUser()` で認証済みユーザーを確認してください。`anon` キーのみでのアクセスを許可する場合は、その理由を明示的にコメントしてください。
    2.  **CORS Configuration**: ブラウザから直接呼び出す場合は、明示的なCORS設定を記述してください。`Access-Control-Allow-Origin: '*'` の使用は開発環境に限定し、本番環境では許可ドメインを列挙してください。
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
    3.  **Secret Management**: APIキー・外部サービス認証情報は `Deno.env.get('SECRET_NAME')` で取得し、コードへのハードコードを厳禁とします。シークレットは `supabase secrets set` で登録してください。
    4.  **No `--no-verify-jwt` in Production**: `supabase functions deploy --no-verify-jwt` は開発・デバッグ専用です。本番環境でJWT検証を無効化することは、認証なしでの関数実行を許可する重大なセキュリティホールです。

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
    2.  **Logging**: `console.log` / `console.error` はSupabaseダッシュボードの Edge Function Logs に自動送信されます。重要な操作（外部API呼び出し、DB書き込み等）の結果を構造化ログ（JSON形式）で記録してください。
    3.  **Retry Safety**: Edge Functionsはリトライされる可能性があるため、**冪等性**を確保してください。重複実行を防ぐため、リクエストIDやidempotency keyの活用を推奨します。

### Rule 13.4: The Edge Functions Local Development Protocol
-   **Law**: Edge Functionsの開発は `supabase functions serve` を使用したローカル開発を標準とし、本番環境への直接デプロイによるデバッグを禁止します。
-   **Action**:
    1.  **Local Serve**: `supabase functions serve function-name --env-file .env.local` でローカル実行し、動作確認を行ってください。
    2.  **Shared Code**: 複数のEdge Functions間で共有するユーティリティは `supabase/functions/_shared/` ディレクトリに配置してください。`_` プレフィックスのディレクトリはデプロイ対象外です。
    3.  **Import Map**: 依存関係は `import_map.json` で管理し、バージョンを固定してください。

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
-   **Law**: Realtimeチャネルの設計は、認証・帯域制御・接続数管理の観点で最適化しなければなりません。
-   **Action**:
    1.  **RLS Enforcement**: Postgres Changesは自動的にRLSポリシーを通過するため、RLSが正しく設定されていればセキュリティは担保されます。ただし、`USING (true)` のテーブルは全データが全ユーザーにブロードキャストされる点に注意してください。
    2.  **Channel Granularity**: チャネル名は細粒度（例: `room:${roomId}`）に設計してください。1つの「全体チャネル」に全イベントを流すと、全クライアントが全イベントを受信し帯域を浪費します。
    3.  **Connection Limits**: 同時接続数にはプランごとの上限があります（Free: 200, Pro: 500, Team: 10,000）。不要になったチャネルは `supabase.removeChannel(channel)` で明示的にクリーンアップしてください。
    4.  **Throttling**: 高頻度イベント（マウス移動等）はクライアント側で **throttle**（100-200ms間隔）してから送信してください。サーバー側の処理能力を超えるイベント送信はメッセージドロップの原因となります。
    5.  **Unsubscribe on Unmount**: React等のコンポーネントでは、アンマウント時に必ず `supabase.removeChannel()` を呼び出してください。メモリリークと不要な接続の温床です。
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

---

## 15. Cron & Queues設計戦略 (Cron & Queues Design Strategy)

### Rule 15.1: The pg_cron Scheduling Protocol
-   **Law**: 定期実行タスク（データパージ、集計バッチ、ヘルスチェック等）には **`pg_cron`** を使用し、外部スケジューラへの依存を最小化してください。
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
    3.  **Monitoring**: Cronジョブの実行結果は `cron.job_run_details` ビューで確認可能です。月次で実行履歴をレビューし、失敗ジョブがないことを確認してください。
    4.  **Resource Guard**: 大量データを処理するCronジョブは、バッチサイズを制限（`LIMIT 10000`）し、DB負荷スパイクを防止してください。

### Rule 15.2: The Message Queue Protocol (pgmq / Supabase Queues)
-   **Law**: 非同期処理（メール送信、外部API呼び出し、重い計算等）は **Supabase Queues (pgmq)** を使用し、同期的なリクエスト処理内で実行することを禁止します。
-   **Action**:
    1.  **Queue-First Architecture**: ユーザーのリクエスト処理内で外部APIの呼び出しやメール送信を行わないでください。メッセージをキューに投入し、ワーカー（Edge Function/pg_cron）が非同期で処理する設計としてください。
    2.  **Retry Strategy**: メッセージ処理失敗時のリトライはExponential Backoff（`1s → 2s → 4s → 8s → max 30s`）を実装してください。一定回数（5回）のリトライ失敗後はDead Letter Queue（DLQ）に移動し、手動対応としてください。
    3.  **Visibility Timeout**: メッセージの可視性タイムアウト（`vt`）は処理時間の**2倍以上**に設定してください。タイムアウトが短すぎると、処理中のメッセージが再配信され二重処理が発生します。
    4.  **Message Size**: キューメッセージは**最小限のデータ**（IDと操作種別のみ）を含めてください。大量データをメッセージに詰め込むのではなく、本体データはDBに保持し、メッセージにはポインタ（ID）のみ含めるパターンを推奨します。
-   **Anti-pattern**: Server Action内で `await sendEmail(...)` を直接実行し、ユーザーにメール送信完了まで待たせること。キューに投入して即座にレスポンスを返してください。

### Rule 15.3: The Database Webhook Protocol
-   **Law**: テーブルの変更イベント（INSERT/UPDATE/DELETE）を外部サービスに通知する場合は **Database Webhooks** を使用し、ポーリングベースの設計を排除してください。
-   **Action**:
    1.  **Event-Driven**: Webhookはテーブルのトリガーイベントに対して自動的にHTTPリクエストを発行します。外部サービス（Slack通知、Analytics、CRM連携等）へのリアルタイム連携に使用してください。
    2.  **Idempotency**: Webhookの受信側は冪等に設計してください。ネットワーク障害によるリトライで同一イベントが複数回配信される可能性があります。
    3.  **Secret Header**: Webhookリクエストにはシークレットヘッダー（`X-Webhook-Secret`）を付与し、受信側で検証してください。未検証のWebhookは、第三者からの偽装リクエストを受け入れるセキュリティホールです。

---

## 16. Observability & FinOps戦略 (Observability & FinOps Strategy)

### Rule 16.1: The Database Performance Monitoring Protocol
-   **Law**: データベースのパフォーマンスは、**能動的な監視と予防的な最適化**により維持しなければなりません。「遅いと感じてから対応する」リアクティブなアプローチを禁止します。
-   **Action**:
    1.  **pg_stat_statements**: `pg_stat_statements` 拡張を有効化し、**実行頻度Top 20 + 平均実行時間Top 20** のクエリを月次でレビューしてください。`mean_exec_time` が 100ms を超えるクエリは最適化候補です。
        ```sql
        -- 最も遅いクエリTop 10
        SELECT query, calls, mean_exec_time, total_exec_time
        FROM pg_stat_statements
        ORDER BY mean_exec_time DESC
        LIMIT 10;
        ```
    2.  **Index Advisor**: Supabase Dashboardの **Index Advisor** を活用し、推奨インデックスの提案を定期的に確認してください。提案されたインデックスを盲目的に適用するのではなく、書き込みパフォーマンスへの影響も考慮して判断してください。
    3.  **Connection Monitoring**: `pg_stat_activity` で現在のアクティブ接続数を監視し、`max_connections` の **70%** を超えた場合はアラートを発報してください。接続枯渇はサービス全停止に直結します。
    4.  **Table Bloat**: `pg_stat_user_tables` で `n_dead_tup`（デッドタプル数）を監視し、テーブルサイズの **20%** を超えた場合は `VACUUM ANALYZE` を手動実行してください。Auto Vacuumのデフォルト設定では対応しきれない場合があります。

### Rule 16.2: The Supabase Dashboard Monitoring Checklist
-   **Law**: 以下の項目を**週次**で確認し、異常値を早期検知してください。
-   **Checklist**:
    - [ ] **Database Health**: CPU使用率が持続的に **70%** を超えていないか
    - [ ] **Disk Usage**: ストレージ使用量がプラン上限の **80%** に達していないか
    - [ ] **API Requests**: 5xx エラー率が **0.1%** を超えていないか
    - [ ] **Auth Users**: 新規登録のスパイク（ボット登録疑い）がないか
    - [ ] **Edge Function Invocations**: エラー率とレイテンシの推移
    - [ ] **Realtime Connections**: 同時接続数がプラン上限に接近していないか
    - [ ] **Storage**: ストレージ帯域の消費量と増加率

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

    2.  **Query Optimization for Cost**: `select('*')` を禁止し、必要なカラムのみ指定してください。これにより転送データ量（Bandwidth課金）を削減できます。
    3.  **Storage Tiering**: CDN（Cloudflare等）で画像・静的アセットをキャッシュし、Supabase Storageへの直接アクセスを最小化してください。帯域課金の最大の削減策です。
    4.  **Free Tier Guard**: 開発・ステージング環境はFree Tierプロジェクトを使用し、本番環境のコストを分離してください。Free Tierプロジェクトは7日間非アクティブで自動停止される点に注意（定期的なヘルスチェックpingを設定）。
    5.  **Compute Add-on Rightsizing**: DB Compute Add-onは実際のCPU/メモリ使用量に基づいて適切なサイズを選択してください。過剰なComputeは直接的なコスト浪費です。

### Rule 16.4: The Log Management Protocol
-   **Law**: Supabaseが生成するログ（API、Auth、Database、Edge Functions）を一元管理し、インシデント調査に即座に活用可能な状態を維持しなければなりません。
-   **Action**:
    1.  **Log Drain**: 本番環境では、Supabaseの **Log Drain** 機能を使用して外部ログ管理サービス（Datadog、Logflare、BigQuery等）にログを転送してください。Supabaseダッシュボードのネイティブログは保持期間が限定されています。
    2.  **Structured Logging**: Edge Functions内では `console.log(JSON.stringify({ event, userId, duration }))` の形式で構造化ログを出力し、検索・フィルタリングを容易にしてください。
    3.  **PII Exclusion**: ログにPII（メールアドレス、パスワード、トークン等）を含めることを厳禁とします。ログは開発者全員がアクセス可能であり、PIIの記録はGDPR/APPI違反のリスクを生みます。

---

## 17. AI & ベクトル検索戦略 (AI & Vector Search Strategy)

### Rule 17.1: The pgvector Architecture Protocol
-   **Law**: Supabaseでベクトル検索（セマンティック検索、レコメンデーション、RAG等）を実装する場合は **`pgvector`** 拡張を使用し、Embeddingの保存・検索・インデックス戦略を体系的に設計しなければなりません。
-   **Action**:
    1.  **Extension Enable**: `CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA extensions;` でpgvectorを有効化してください。`public` スキーマへのインストールは §2.2（Schema Separation）に違反します。
    2.  **Column Definition**: Embeddingカラムは `vector(dimension)` 型で次元数を明示してください。OpenAI `text-embedding-3-small` は1536次元、`text-embedding-3-large` は3072次元です。
        ```sql
        ALTER TABLE public.documents
        ADD COLUMN embedding vector(1536);
        ```
    3.  **Cosine Similarity**: 類似度検索には **コサイン類似度**（`<=>` 演算子）を標準として使用してください。内積（`<#>`）やL2距離（`<->`）は特殊なユースケースに限定します。
    4.  **RLS Integration**: Embeddingカラムを含むテーブルにもRLSを必ず適用してください。ベクトル検索結果がRLSを迂回する設計（`service_role`での直接検索→クライアントへの無検証返却）は禁止です。

### Rule 17.2: The Vector Index Strategy
-   **Law**: ベクトルのインデックスは、データサイズと検索精度の要件に基づいて適切な型を選択しなければなりません。
-   **Action**:
    1.  **HNSW（推奨）**: 検索精度・速度のバランスが最良。メモリ使用量は大きいが、大半のユースケースに適合。
        ```sql
        CREATE INDEX idx_documents_embedding ON public.documents
        USING hnsw (embedding vector_cosine_ops)
        WITH (m = 16, ef_construction = 64);
        ```
    2.  **IVFFlat**: メモリ制約がある場合に使用。`lists` パラメータはデータ行数の `sqrt(N)` を目安にしてください。
    3.  **インデックス作成タイミング**: インデックスはデータが**ある程度蓄積されてから**（数千行以上）作成してください。空テーブルにインデックスを作成しても、クエリプランナーが有効活用できません。
    4.  **Probes Setting**: IVFFlatの場合、検索時に `SET LOCAL ivfflat.probes = 10;` で探索リスト数を調整してください。精度と速度のトレードオフです。

### Rule 17.3: The RAG Pipeline Protocol
-   **Law**: RAG（Retrieval-Augmented Generation）パイプラインを構築する場合、Embeddingの生成・保存・検索・取得の全工程を一貫した設計で管理しなければなりません。
-   **Action**:
    1.  **Embedding Generation**: Embeddingの生成はEdge Functionまたはサーバーサイドで実行してください。クライアントからの直接API呼び出し（OpenAI APIキーの露出）は厳禁です。
    2.  **Chunk Strategy**: 長文ドキュメントはチャンク（500-1000トークン程度）に分割してからEmbeddingを生成してください。ドキュメント全体の単一Embeddingは検索精度が低下します。
    3.  **Metadata Co-Storage**: Embeddingと一緒に**元テキスト・ソースURL・チャンク位置**をメタデータとして同一テーブルに保存してください。Embeddingのみ保存して元データを別管理すると、検索結果から原文を復元できなくなります。
    4.  **RPC Search Function**: ベクトル検索はRPC関数（`SECURITY DEFINER`）経由で実行し、RLSフィルタと組み合わせてください。
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
    5.  **Re-Embedding Strategy**: ソースデータが更新された場合は、対応するEmbeddingも**必ず再生成**してください。古いEmbeddingと新しいテキストの不整合は、検索品質の致命的劣化を引き起こします。

---

## 18. Auth高度設計戦略 (Advanced Auth Design Strategy)

### Rule 18.1: The API Key Security Protocol（2025年新モデル）
-   **Law**: Supabaseの新APIキーシステム（2025年導入）に基づき、**Publishable Key** と **Secret Key** の役割を正しく理解し、セキュリティ境界を厳格に管理しなければなりません。
-   **Action**:
    1.  **Publishable Key（旧 anon key）**: クライアントサイドに公開可能な低権限キー。RLSによる制御のみ。ブラウザやモバイルアプリに埋め込んで使用。
    2.  **Secret Key（旧 service_role key）**: サーバーサイド専用の高権限キー。RLSを完全にバイパス。**クライアントコードへの埋め込み厳禁**。
    3.  **Key Rotation**: Secret Keyが漏洩した場合、Supabaseダッシュボードから即座にローテーションしてください。2025年以降、GitHubパブリックリポジトリで検出されたSecret Keyは**自動的に無効化**されます。
    4.  **RSA Asymmetric Keys**: 2025年5月以降の新規プロジェクトではRSA非対称鍵がデフォルトです。JWTの検証はPublic Keyで行い、Secret Keyの共有なしにトークン検証を外部サービスで実行可能です。
    5.  **Data API Disable**: APIを公開不要なプロジェクト（内部ツール等）では、Data API自体を無効化してください（2025年新機能）。攻撃面の根本的な削減です。

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
    4.  **Cleanup**: 昇格されなかった匿名ユーザーは、一定期間（30日等）後に `pg_cron` バッチで自動削除してください。放置すると `auth.users` テーブルが無限増殖し、Auth MAU課金に影響します。
    5.  **Session Refresh**: `supabase.auth.onAuthStateChange()` でセッション状態の変更を監視し、トークン更新を適切に処理してください。トークン期限切れの放置は、ユーザーの突然のログアウトを引き起こします。

---

## 19. テスト戦略 (Testing Strategy)

### Rule 19.1: The RLS Policy Testing Protocol
-   **Law**: RLSポリシーは**自動化されたテスト**で検証し、手動確認のみに依存することを禁止します。ポリシー変更時は、変更と同じマイグレーションファイル内にテストSQLを含めてください。
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
    4.  **Seed Data**: テスト用のシードデータは `supabase/seed.sql` で管理し、テスト実行前に確定的な状態を構築してください。

---

## 20. マルチ環境 & ブランチング戦略 (Multi-Environment & Branching Strategy)

### Rule 20.1: The Environment Isolation Protocol
-   **Law**: 開発（Dev）・ステージング（Staging）・本番（Production）の3環境を物理的に分離し、各環境間のデータ汚染を防止しなければなりません。
-   **Action**:
    1.  **Separate Projects**: 各環境は**独立したSupabaseプロジェクト**として作成してください。1つのプロジェクトを環境切り替え（env変数のみの変更）で使い回す設計は、データ汚染と設定ミスの温床です。
    2.  **Environment Variable Isolation**: 各環境の `SUPABASE_URL` と `SUPABASE_ANON_KEY` は環境変数で厳格に管理し、ハードコードを禁止してください。
    3.  **Production Data Isolation**: 本番データを開発/ステージング環境にコピーする場合は、PII（個人情報）を**必ず匿名化・マスキング**してください。本番データの無加工コピーはAPPI/GDPR違反のリスクです。
    4.  **Migration Flow**: マイグレーションの適用順序は `Dev → Staging → Production` の一方向です。Productionへの直接適用は §7.6（Zero SQL Editor Policy）により禁止されています。
    5.  **Seed Data Separation**: 各環境のシードデータ（`seed.sql`）は環境別に管理し、開発用テストデータが本番に混入することを防いでください。

### Rule 20.2: The Supabase Branching Protocol
-   **Law**: Supabase Branching（2025年 Public Alpha）を活用して、スキーマ変更のプレビュー・テストを安全に実行しなければなりません。
-   **Action**:
    1.  **Branch = Isolated Instance**: 各ブランチは独立したSupabaseインスタンス（独自のAPIクレデンシャル、Auth、Storage）として機能します。本番環境に影響を与えずにスキーマ変更をテストできます。
    2.  **Dashboard / CLI Creation**: ブランチはSupabaseダッシュボード、CLI（`supabase branches create`）、またはManagement APIから作成可能です。Git連携は必須ではありません（Branching 2.0）。
    3.  **Migration Preview**: ブランチでマイグレーションを適用し、スキーマの整合性・RLSポリシーの動作・パフォーマンスへの影響を本番適用前に検証してください。
    4.  **Branch Lifecycle**: テスト完了後のブランチは速やかに削除してください。放置されたブランチはコンピュートリソースを消費し、コスト増の原因となります。
    5.  **No Data Persistence**: ブランチは一時的な検証環境です。ブランチ内のデータはマージ時に本番へ移行されません。テストデータのみ使用し、重要なデータをブランチに保存しないでください。

---

## 21. PostgREST API設計戦略 (PostgREST API Design Strategy)

### Rule 21.1: The Select Optimization Protocol
-   **Law**: PostgREST（Supabase Auto-generated REST API）でのデータ取得は、**必要最小限のカラム**のみを指定し、`select('*')` の安易な使用を禁止します。
-   **Action**:
    1.  **Explicit Select**: `.select('id, name, created_at')` のように必要カラムを明示してください。`select('*')` は転送データ量を増大させ、Bandwidth課金に直結します（§16.3参照）。
    2.  **Computed Columns**: PostgreSQLの Generated Columns やViewを活用し、API経由で計算結果を直接返却してください。クライアント側での再計算を排除します。
    3.  **Type Generation**: `select()` で指定したカラムリストは `supabase gen types` で生成される型にも反映されます。型安全性を維持するため、select文の変更時は型の再生成を忘れずに実行してください。

### Rule 21.2: The Filtering & Embedding Protocol
-   **Law**: PostgRESTのフィルタリングと**Embedding（テーブル結合）** を正しく活用し、クライアント側でのデータ加工を最小化しなければなりません。
-   **Action**:
    1.  **Filter Operators**: `.eq()`, `.in()`, `.gte()`, `.lte()`, `.like()`, `.ilike()` などのPostgRESTフィルタを活用し、サーバーサイドでデータを絞り込んでください。全件取得してクライアント側でフィルタリングする設計は禁止です。
    2.  **Embedding (Foreign Table Joins)**: 外部キーで関連するテーブルのデータを**1回のリクエスト**で取得してください。
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
    4.  **Deep Nesting Limit**: Embeddingのネスト深度は**3段階以下**に制限してください。深いネストはクエリの複雑度を指数的に増大させ、レスポンスタイムの悪化を招きます。

### Rule 21.3: The Pagination & Aggregate Protocol
-   **Law**: リスト取得APIは**必ずページネーション**を実装し、全件取得を禁止します。集約関数はPostgRESTの機能を活用してください。
-   **Action**:
    1.  **Range Pagination**: `.range(from, to)` でオフセットベースのページネーションを実装してください。レスポンスヘッダー `Content-Range` で総件数を取得可能です。
    2.  **Count Option**: 総件数が必要な場合は `{ count: 'exact' }` オプションを使用してください。ただし、大量データのテーブルでは `count: 'estimated'` を推奨します（`exact` は全行スキャンが発生）。
    3.  **Cursor Pagination**: 大量データ（100万行以上）のテーブルでは、`created_at` や `id` をカーソルとするKeyset Paginationを採用してください。オフセットベースは深いページで著しくパフォーマンスが劣化します。
    4.  **Max Page Size**: 1リクエストあたりの最大件数は **1000件**（PostgRESTデフォルト）を超えないでください。やむを得ない場合は `supabase_settings` で `max_rows` を調整可能ですが、クライアントが大量データを一括取得する設計自体を見直してください。

---

## 22. CLI & ローカル開発戦略 (CLI & Local Development Strategy)

### Rule 22.1: The CLI-First Workflow Protocol
-   **Law**: Supabase CLIを開発ワークフローの中心に据え、ダッシュボードGUI操作への依存を最小化しなければなりません。
-   **Action**:
    1.  **Local Development**: `supabase init` → `supabase start` でローカル開発環境を構築してください。ローカル環境では本番と同一のPostgreSQL・Auth・Storage・Edge Functionsが動作します。
    2.  **Migration Workflow**: スキーマ変更は `supabase migration new <name>` で新規マイグレーションファイルを作成し、SQLを記述してください。ダッシュボードでの手動変更は §7.6（Zero SQL Editor Policy）により禁止です。
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
-   **Law**: Supabase本番環境では**Supavisor**（Supabase公式コネクションプーラー、PgBouncer後継）を経由してデータベースに接続しなければなりません。直接接続は特定の用途に限定します。
-   **Action**:
    1.  **Pooler Endpoint**: アプリケーションからの接続は、ダッシュボードで取得できる**Pooler接続文字列**（ポート `6543`）を使用してください。Direct接続（ポート `5432`）はマイグレーション実行時やPrepared Statementsが必要な場合に限定します。
    2.  **Serverless Optimization**: サーバーレス環境（Vercel Functions, Edge Functions等）では、リクエストごとにDB接続が生成・破棄されます。Supavisorは**ホットコネクション**をプール管理し、接続のオーバーヘッド（TCP handshake, TLS negotiation, PostgreSQL startup）を大幅に削減します。
    3.  **IPv6 Mediation**: Supavisorは IPv4 → IPv6 のメディエーションを提供します。GitHub Actions等のIPv4環境からの接続はPooler経由で行い、IPv6接続エラーを回避してください。
    4.  **Query Load Balancing**: Supavisorはリードレプリカが有効な環境で**読み取りクエリを自動分散**します。書き込みはプライマリ、読み取りはレプリカに振り分けることで、負荷を分散してください。

### Rule 23.2: The Pool Size Design Protocol
-   **Law**: コネクションプールのサイズは、PostgreSQLの最大接続数とアプリケーションの特性に基づいて**計算式で設計**しなければなりません。デフォルト値の放置を禁止します。
-   **Action**:
    1.  **Pool Size Calculation**: Supavisorのプールサイズは、ダッシュボードの「Database Settings > Connection Pooling」で設定してください。計算指針:
        -   PostgREST API中心のアプリ: DBの最大接続数の **40%** をSupavisorに割当
        -   直接接続中心のアプリ: DBの最大接続数の **80%** をSupavisorに割当
    2.  **Max Connections Awareness**: PostgreSQLの `max_connections` はプランにより異なります（Free: 60, Pro: 200, Team: 400等）。この上限を超える接続要求は「Too many connections」エラーとなります。
    3.  **Connection Monitoring**: ダッシュボードの **Database > Connections** ページで接続数推移を定期的に監視してください。Teams/Enterpriseプランでは接続種別（Postgres, PostgREST, Auth, Storage等）ごとの内訳が確認可能です。
    4.  **Connection Leak Prevention**: アプリケーション側で `supabase.removeAllChannels()` やDB接続の明示的クローズを忘れると、コネクションリークが発生します。サーバーレス関数では必ずリクエスト完了時に接続を解放してください。

### Rule 23.3: The Connection Mode Decision Protocol
-   **Law**: アプリケーションの特性に応じて、**Transaction Mode**と**Session Mode**を正しく使い分けなければなりません。
-   **Action**:
    1.  **Transaction Mode（推奨）**: サーバーレス環境やAPI経由の短命な接続に最適。トランザクション完了時にコネクションがプールに返却されます。**デフォルトでTransaction Modeを使用してください。**
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
-   **Law**: 本番環境のデータは**多層バックアップ戦略**で保護しなければなりません。Supabaseのマネージドバックアップのみに依存する設計を禁止します。
-   **Action**:
    1.  **Daily Automated Backups**: Proプラン以上ではSupabaseが日次自動バックアップを7日分保持します。ダッシュボードの **Database > Backups** で状態を定期的に確認してください。
    2.  **Point-in-Time Recovery (PITR)**: より細かいRPO（Recovery Point Objective）が必要な場合は**PITRを有効化**してください。任意の時点への復元が可能になります（Proプラン以上で利用可能）。
    3.  **External Backup Redundancy**: Supabaseのバックアップに加え、外部への定期エクスポートを実装してください:
        -   **`pg_dump`**: `pg_dump --format=custom` で圧縮バックアップを生成し、S3/R2/GCS等のObject Storageに保存
        -   **スケジュール実行**: Edge Functionsまたは外部スケジューラ（GitHub Actions, Cloud Scheduler等）で日次/週次実行
        -   **別リージョン保管**: バックアップファイルは本番DBとは**別リージョン**に保管してください。同一リージョンの障害で両方失われるリスクを回避します。
    4.  **Backup Encryption**: バックアップにPII（個人情報）が含まれる場合、保存前に**暗号化**してください。暗号化キーはバックアップとは別の場所（Vault, AWS KMS等）で管理してください。
    5.  **Free Plan Warning**: Freeプランではバックアップのダウンロードが不可です。`pg_dump` または `supabase db dump` による自前バックアップを必ず設定してください。

### Rule 24.2: The Disaster Recovery Planning Protocol
-   **Law**: 災害復旧（DR）手順は**文書化・テスト済み**でなければなりません。「復旧手順が存在しない」「テストされていない」状態での本番運用を禁止します。
-   **Action**:
    1.  **RTO/RPO Definition**: 事前にRTO（目標復旧時間）とRPO（目標復旧時点）を定義してください:
        -   **RTO目安**: 日次バックアップからの復元 = 数時間〜半日、PITR = 数十分
        -   **RPO目安**: 日次バックアップ = 最大24時間のデータ損失、PITR = 数分
    2.  **Recovery Runbook**: 以下を含む復旧手順書を作成し、チームで共有してください:
        -   Supabaseダッシュボードからの復元手順
        -   `pg_restore` によるバックアップからの復元手順
        -   PITRの時点指定復元手順
        -   Auth/Storage/Edge Functionsを含む全サービスの復旧チェックリスト
    3.  **DR Test**: 四半期に1回以上、ステージング環境で**復旧テスト**を実施してください。バックアップから実際に復元し、データ整合性とアプリケーション動作を確認します。テストされていないバックアップは「存在しない」のと同等です。
    4.  **Critical Table Identification**: 全テーブルを重要度でランク付けし、復旧優先順位を明示してください:
        -   **Tier 1（即時復旧）**: `auth.users`, 決済データ, コアビジネスデータ
        -   **Tier 2（6時間以内）**: ユーザーコンテンツ, 設定データ
        -   **Tier 3（24時間以内）**: ログ, 分析データ, キャッシュ
    5.  **Incident Communication**: 障害発生時のコミュニケーション手順（ユーザー通知、ステークホルダー連絡、ステータスページ更新）も復旧手順書に含めてください。

---

## 25. Rate Limiting & API保護戦略 (Rate Limiting & API Protection Strategy)

### Rule 25.1: The Auth Rate Limiting Protocol
-   **Law**: Supabase Authのビルトインレート制限を理解し、アプリケーション設計に組み込まなければなりません。レート制限を無視した設計は、正規ユーザーのブロックやサービス拒否を引き起こします。
-   **Action**:
    1.  **Built-in Limits Awareness**: Supabase Authには以下のデフォルトレート制限が適用されます:
        -   **メール送信**: 1時間あたり同一メールアドレスに3通まで（確認メール、パスワードリセット等）
        -   **SMS送信**: 1時間あたり同一電話番号に30通まで
        -   **サインアップ**: IPごとのレート制限あり
    2.  **Management API Customization**: ダッシュボードまたはManagement APIを通じてレート制限値をカスタマイズしてください。デフォルト値はスタートアップ向けであり、トラフィックの増加に応じて調整が必要です。
    3.  **Client-Side Throttling**: クライアント側でも認証リクエストにスロットリングを実装してください。ボタンの連打やリトライループによる不必要なレート制限超過を防ぎます。
    4.  **Error Handling**: レート制限超過時のHTTP 429レスポンスを適切にハンドリングしてください。ユーザーに「しばらくお待ちください」等のメッセージを表示し、`Retry-After` ヘッダーに基づいてリトライタイミングを制御してください。

### Rule 25.2: The Custom API Rate Limiting Protocol
-   **Law**: PostgREST API / Edge FunctionsへのカスタムRate Limitingを実装し、不正利用・DDoS・コスト爆発を防止しなければなりません。
-   **Action**:
    1.  **Edge Functions Rate Limiting**: Edge Functionsでは、Upstash Redis等の外部ストアを使用してリクエストレートを制御してください。Sliding Windowアルゴリズムを推奨します。
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
    2.  **Per-User Limiting**: 匿名ユーザーは`IP`ベース、認証済みユーザーは`user_id`ベースでRate Limitingを適用してください。認証済みユーザーには匿名より高いレートを許可するティア制を推奨します。
    3.  **Endpoint-Specific Limits**: 全エンドポイントに均一のレートを適用せず、リソース消費量に応じて差別化してください:
        -   **読み取り系**: 60リクエスト/分（緩め）
        -   **書き込み系**: 20リクエスト/分（厳しめ）
        -   **認証系**: 5リクエスト/分（最も厳格）
    4.  **Abuse Detection**: 異常なパターン（短時間に大量のサインアップ、同一IPからの連続ログイン失敗等）を検出し、一時的なIPブロックまたはCAPTCHAチャレンジを発動するロジックを実装してください。

---

## 26. Vault & シークレット管理戦略 (Vault & Secret Management Strategy)

### Rule 26.1: The Vault Encrypted Storage Protocol
-   **Law**: APIキー、外部サービスのシークレット、暗号化キー等の機密情報は、Supabase **Vault**（PostgreSQL拡張機能）を使用して暗号化保存しなければなりません。プレーンテキストでのDB保存や環境変数への直接ハードコーディングを禁止します。
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
    4.  **pgsodium Deprecation**: `pgsodium` 拡張機能は非推奨サイクルに入っています。新規プロジェクトでは `pgsodium` を直接使用せず、**Vault経由**でシークレット管理を行ってください。Vaultの内部実装はpgsodiumから透過的に移行され、APIに影響はありません。
    5.  **Use Cases**: Vault内の暗号化シークレットは、PostgreSQL Functions、Triggers、Database Webhooksから参照可能です。Edge Functionsからは環境変数（`Deno.env.get()`）を使用してください。

### Rule 26.2: The Secret Rotation & Lifecycle Protocol
-   **Law**: シークレットは**定期的にローテーション**し、漏洩時は即座に無効化しなければなりません。ローテーション手順が文書化されていない状態を禁止します。
-   **Action**:
    1.  **Rotation Schedule**: 以下のローテーション間隔を基準にしてください:
        -   **Supabase API Keys**: 90日ごと（ダッシュボードから再生成）
        -   **外部サービスAPIキー**: サービスの推奨に準拠（最長90日）
        -   **JWT Secret**: 年次（影響範囲が大きいため計画的に実施）
    2.  **Automated Rotation**: 可能な限りシークレットローテーションを自動化してください。Vault内のシークレット更新 → 依存するFunctions/Triggersの動作確認 → 旧シークレットの無効化、の順序で実行します。
    3.  **Leak Response**: Supabaseは2025年から**GitHub公開リポジトリにプッシュされたAPIキーを自動検出・無効化**する機能を提供しています。この機能に依存せず、`.env` ファイルのgitignore設定と、CI/CDでのシークレットスキャン（GitHub Secret Scanning, GitLeaks等）を必ず実施してください。
    4.  **Environment Separation**: 開発/ステージング/本番のシークレットは完全に分離してください。同一のAPIキーを複数環境で共有することを禁止します。
    5.  **Audit Trail**: シークレットの作成・更新・削除の履歴を追跡可能にしてください。Vault操作時にaudit_logsテーブルにイベントを記録することを推奨します。

---

## 27. Foreign Data Wrappers (FDW) 戦略

### Rule 27.1: The FDW Architecture Protocol
-   **Law**: 外部データソース（Stripe, Firebase, S3, 他のPostgreSQL等）へのアクセスは、Supabase **Wrappers**（Foreign Data Wrappers拡張機能）を活用し、SQLインターフェースで統一的にアクセスしなければなりません。
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
-   **Law**: FDWの認証情報は**Vault**で暗号化管理し、外部テーブルは**非公開スキーマ**に配置しなければなりません。パフォーマンス対策としてMaterialized Viewの活用を義務付けます。
-   **Action**:
    1.  **Vault Integration**: FDWの認証情報（APIキー、DB接続文字列等）は必ず`vault.create_secret()`で暗号化保存してください（§26.1参照）。FDWのSERVERオプションに平文でキーを記述することを禁止します。
        ```sql
        -- Vault にシークレット保存
        SELECT vault.create_secret('sk_live_xxx', 'stripe_api_key');
        -- FDW作成時にVault参照
        CREATE SERVER stripe_server
          FOREIGN DATA WRAPPER stripe_wrapper
          OPTIONS (api_key_id (SELECT id FROM vault.decrypted_secrets WHERE name = 'stripe_api_key'));
        ```
    2.  **Private Schema Placement**: 外部テーブルは`public`スキーマや公開APIスキーマに配置**しないでください**。専用のプライベートスキーマ（例: `fdw_stripe`, `fdw_firebase`）に配置し、Data API経由の直接アクセスを遮断してください。
    3.  **Materialized Views**: FDW経由の外部APIコールはレイテンシーが高いため、頻繁にアクセスするデータは**Materialized View**で定期的にキャッシュしてください。`pg_cron`でリフレッシュスケジュールを設定します。
    4.  **SECURITY DEFINER Functions**: 外部テーブルのデータを公開APIに部分的に公開する場合は、`SECURITY DEFINER`関数をpublic/apiスキーマに作成し、必要なカラムのみを返却する薄いラッパーとしてください。外部テーブルを直接公開することを禁止します。
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
-   **Law**: マルチテナントアプリケーションでは、テナント間のデータ分離を**RLSとtenant_idカラム**で強制しなければなりません。アプリケーションロジックのみに依存した分離を禁止します。
-   **Action**:
    1.  **tenant_id Column**: テナント分離が必要な全テーブルに`tenant_id UUID NOT NULL`カラムを追加してください。このカラムはRLSポリシーのフィルタ条件として使用します。
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
    2.  **RLS Policy with tenant_id**: JWTの`app_metadata`にテナントIDを格納し、RLSポリシーで照合してください。ユーザーが自分のテナントIDを改ざんできないよう、`app_metadata`（管理者のみ変更可能）を使用します。
        ```sql
        ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
        CREATE POLICY "tenant_isolation" ON public.projects
          FOR ALL
          USING (tenant_id = (auth.jwt() -> 'app_metadata' ->> 'tenant_id')::UUID);
        ```
    3.  **Tenant Assignment**: ユーザー登録時にtenant_idを`app_metadata`に自動設定してください。Auth Hooksまたはサーバーサイドロジックで実装します。
    4.  **Shared vs Dedicated**: アーキテクチャの選択指針:
        -   **Shared Database + RLS**（推奨）: コスト効率が高く、管理が単純。100テナント以下のSaaSに最適
        -   **Schema-per-Tenant**: 論理的分離が強い。規制要件がある場合に検討
        -   **Database-per-Tenant**: 完全分離。エンタープライズ顧客の厳格な要件がある場合のみ

### Rule 29.2: The Tenant Isolation Audit Protocol
-   **Law**: テナント分離は**定期的に監査・テスト**し、データ漏洩がないことを検証しなければなりません。
-   **Action**:
    1.  **Cross-Tenant Query Test**: テストスイートに「テナントAのユーザーがテナントBのデータにアクセスできないこと」を検証するテストケースを必ず含めてください。
    2.  **Missing tenant_id Check**: 以下のクエリで`tenant_id`カラムを持たないテーブルを定期的に検出してください:
        ```sql
        SELECT table_name FROM information_schema.tables t
        WHERE t.table_schema = 'public'
          AND t.table_type = 'BASE TABLE'
          AND NOT EXISTS (
            SELECT 1 FROM information_schema.columns c
            WHERE c.table_schema = t.table_schema
              AND c.table_name = t.table_name
              AND c.column_name = 'tenant_id'
          );
        ```
    3.  **RLS Enforcement Check**: `public`スキーマの全テーブルでRLSが有効化されているか定期的に監査してください（§3参照）。
    4.  **Tenant-Aware RBAC**: テナント内の権限管理（admin/member/viewer等）は、RLSポリシーとJWTカスタムクレームを組み合わせて実装してください。テナント横断の管理者権限は`service_role`に限定します。
    5.  **Performance Monitoring**: テナント数の増加に伴うRLSポリシーのパフォーマンス劣化を監視してください。`tenant_id`カラムのインデックスが存在し、RLSポリシーがInitPlanパターン（§3.0参照）を使用していることを確認します。

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
    3.  **search_path必須設定**: `SECURITY DEFINER`関数では必ず`SET search_path = ''`を設定してください。これにより、攻撃者が`search_path`を操作してオブジェクトを偽装するリスクを排除します。
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
-   **Law**: 本番環境では**Log Drain**を設定し、Supabaseの全サービスログ（Database, Auth, Storage, Realtime, Edge Functions, API Gateway）を外部Observabilityプラットフォームに転送しなければなりません。
-   **Action**:
    1.  **Supported Destinations**: 以下のLog Drain先がネイティブサポートされています:
        -   **Datadog**: APIキーとサイトリージョンを設定。ログはgzip圧縮・タグ付きで転送
        -   **Custom HTTP Endpoint**: 任意のHTTPエンドポイントに送信。Edge Functionsでフィルタリング・再構成が可能
    2.  **Plan Requirement**: Log DrainはTeam / Enterprise / Pro プランで利用可能です。Freeプランでは利用不可。
    3.  **Log Retention**: Supabaseのデフォルトログ保持期間は限定的です（プランにより異なる）。長期保存が必要な場合はLog Drainで外部ストレージに転送してください。
    4.  **Structured Logging**: Edge Functions内のログは`console.log(JSON.stringify({...}))`で構造化JSONとして出力してください。外部ツールでのパース・フィルタリングが容易になります。
    5.  **Sensitive Data Filtering**: Log Drainに転送するログから**個人情報（PII）やシークレット**が含まれていないことを確認してください。必要に応じてEdge Function経由でログをフィルタリングし、機密データをマスクしてから転送します。

### Rule 32.2: The External Metrics & Alerting Protocol
-   **Law**: Supabaseの**Metrics API**（Prometheus互換）を活用し、外部監視ツールでカスタムダッシュボードとアラートを構築しなければなりません。
-   **Action**:
    1.  **Prometheus Metrics API**: Supabaseは`/metrics`エンドポイントでPrometheus互換メトリクスを公開します（Beta）。CPU使用率、I/O、WAL、接続数、クエリ統計をスクレイプ可能です。
    2.  **OpenTelemetry**: Supabaseは**OpenTelemetry（OTel）統合**をサポートしています。ログ・メトリクス・トレースをOTel互換ツール（Datadog, Honeycomb, Grafana等）にエクスポート可能です。
    3.  **Datadog Agent**: Datadogエージェントによる詳細なデータベースモニタリングが可能です。クエリメトリクス、サンプル、EXPLAINプランの可視化ができます。**エージェントはDedicated Poolerをバイパスしてホストに直接接続**してください。
    4.  **アラート設計**: 以下のメトリクスに対してアラートを設定してください:
        -   **接続数**: `active_connections / max_connections > 80%` → Warning
        -   **CPU使用率**: `> 90%` が5分以上持続 → Critical
        -   **ディスク使用率**: `> 80%` → Warning、`> 90%` → Critical
        -   **Auth失敗率**: 連続失敗 > 10回/分 → Brute-force検知アラート
        -   **Edge Functions エラー率**: `> 5%` → Warning
    5.  **§16との関係**: 本セクションは§16（内部Observability）を補完します。§16はSupabaseダッシュボード内の監視、§32は外部ツールとの統合に焦点を当てています。

---

## 33. Auth Hooks & Custom Claims戦略 (Auth Hooks & Custom Claims Strategy)

### Rule 33.1: The Custom Access Token Hook Protocol
-   **Law**: JWTに**カスタムクレーム**（ロール、テナントID、権限レベル等）を追加する場合は、Supabase **Auth Hooks（Custom Access Token Hook）**を使用しなければなりません。
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
-   **Law**: ユーザー登録・ログイン等の認証イベントに連動する自動処理は、**Database Trigger on auth.users**で実装しなければなりません。
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
    2.  **SECURITY DEFINER必須**: `auth.users`テーブルへのトリガー関数は`SECURITY DEFINER`で作成してください（§31.1参照）。`auth`スキーマは通常の`anon`/`authenticated`ロールからアクセスできないためです。
    3.  **Error Handling**: トリガー関数内でエラーが発生すると、元の認証操作自体がロールバックされます。`BEGIN...EXCEPTION`ブロックでエラーを適切にハンドリングし、認証フロー全体の失敗を防止してください。
    4.  **Migration管理**: Auth Triggerの作成・変更は必ずマイグレーションファイルで管理してください（§7, §31.2参照）。

---

## 34. Self-hosted & Email Configuration戦略 (Self-hosted & Email Configuration Strategy)

### Rule 34.1: The Self-hosted Deployment Protocol
-   **Law**: Supabaseをセルフホストする場合は、**Docker Compose**を使用し、セキュリティ・バックアップ・アップデートの全責任を自己管理しなければなりません。
-   **Action**:
    1.  **Minimum Requirements**: 本番環境では**8GB+ RAM / 4+ CPU cores**を推奨します。開発環境は4GB RAM / 2 CPU coresで稼働可能です。
    2.  **Critical Environment Variables**: 以下の環境変数を**必ず**デフォルト値から変更してください:
        -   `POSTGRES_PASSWORD`: 強力なパスワード
        -   `JWT_SECRET`: 最低32文字のランダム文字列
        -   `ANON_KEY` / `SERVICE_ROLE_KEY`: JWT_SECRETから生成されたキー
        -   `DASHBOARD_USERNAME` / `DASHBOARD_PASSWORD`: Supabase Studio認証
    3.  **HTTPS必須**: 本番環境では**Caddy**または**Nginx**リバースプロキシでHTTPSを終端してください。HTTP直接公開を禁止します。
    4.  **Data Persistence**: Dockerボリュームでデータ永続化を設定してください。`docker-compose down`でデータが失われるデフォルト設定は本番不可です。
    5.  **Update Strategy**: Supabaseの各コンポーネント（GoTrue, PostgREST, Realtime等）のDockerイメージを定期的に更新してください。バージョン固定（`:latest`タグ禁止）を推奨します。

### Rule 34.2: The Email & SMTP Configuration Protocol
-   **Law**: 本番環境では**カスタムSMTPプロバイダー**を設定し、メールテンプレートをプロジェクトに合わせてカスタマイズしなければなりません。
-   **Action**:
    1.  **Custom SMTP必須**: Supabase組み込みメールサービスには送信制限（1時間あたり3通等）があります。本番環境では外部SMTP（SendGrid, AWS SES, Resend等）を設定してください。
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
-   **Law**: Next.js App Router、SvelteKit、Nuxt等の**SSRフレームワーク**とSupabaseを統合する場合は、`@supabase/ssr`パッケージを使用し、**Cookie-based認証**を実装しなければなりません。`localStorage`によるトークン管理を禁止します。
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
    3.  **localStorage禁止理由**: `localStorage`はXSS攻撃に脆弱であり、SSR/RSCでは利用不可です。Cookie-basedアプローチはSSR・セキュリティ・SEOの全てに対応します。
    4.  **@supabase/auth-helpers非推奨**: 旧パッケージ`@supabase/auth-helpers-nextjs`は非推奨です。`@supabase/ssr`に移行してください。

### Rule 35.2: The Middleware Auth Guard Protocol
-   **Law**: SSRフレームワークでは**Middleware**でセッション更新とルート保護を実装しなければなりません。ただし、Middlewareのみに依存せず、データアクセス層でも認証を検証してください。
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
    3.  **Schema Isolation**: 拡張は`extensions`スキーマに作成することを推奨します（Supabaseデフォルト）。`public`スキーマへの関数汚染を防止します。
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
-   **Law**: `supabase-js`のAPI呼び出しでは、**必ず`error`オブジェクトをチェック**し、一時的なネットワークエラーに対するリトライロジックを実装しなければなりません。
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
    4.  **リトライロジック**: 一時的なネットワークエラー（520等）に対して`fetch-retry`等でリトライを実装してください。ただし、Data APIのコネクションプール枯渇を避けるため、**最大3回・指数バックオフ**を推奨します。
    5.  **タイムアウト**: API呼び出しに**5秒のタイムアウト**を設定し、リクエストの無限ハングを防止してください。

### Rule 37.2: The Realtime Subscription Lifecycle Protocol
-   **Law**: Realtimeサブスクリプションは**必ずコンポーネントのアンマウント時にクリーンアップ**し、再接続処理とスロットリングを適切に実装しなければなりません。
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
    3.  **高頻度更新のスロットリング**: カーソル移動やタイピングインジケーター等の高頻度イベントは、**100-200ms間隔でスロットリング**してからブロードキャストしてください。
    4.  **Channel Status監視**: `channel.on('system', ...)`でチャネルのステータスを監視し、接続状態のフィードバックをユーザーに提供してください。
    5.  **RLS適用**: Realtimeデータはチャネルレベルでもテーブルレベルでもアクセスポリシーを設けてください（§3, §14参照）。

---

## 38. Schema Design Patterns戦略 (Schema Design Patterns Strategy)

### Rule 38.1: The Soft Delete & Data Lifecycle Protocol
-   **Law**: データ削除には**Soft Delete（論理削除）パターン**を採用し、`deleted_at`カラムとRLSポリシーの組み合わせで実装しなければなりません。
-   **Action**:
    1.  **`deleted_at`カラム**: テーブルに`deleted_at TIMESTAMPTZ DEFAULT NULL`を追加してください。物理削除（`DELETE`）の代わりに`UPDATE SET deleted_at = NOW()`で論理削除します。
    2.  **Active Records View**: アクティブレコードのみを返すViewを作成してください:
        ```sql
        CREATE VIEW public.active_profiles AS
          SELECT * FROM public.profiles WHERE deleted_at IS NULL;
        ```
    3.  **RLSによる自動除外**: RLSポリシーで`deleted_at IS NULL`条件を追加し、削除済みレコードをデフォルトで非表示にしてください:
        ```sql
        CREATE POLICY "Hide soft-deleted rows" ON profiles
          FOR SELECT USING (deleted_at IS NULL);
        ```
    4.  **復元機能**: `deleted_at`を`NULL`に戻すことで復元可能です。復元UIも設計してください。
    5.  **物理削除スケジュール**: `pg_cron`（§15.1参照）で、`deleted_at`が一定期間（例: 90日）を超えたレコードを物理削除するバッチジョブを設定してください。

### Rule 38.2: The Audit Trail & JSONB Design Protocol
-   **Law**: データ変更履歴は**Audit Trail（監査証跡）**で追跡し、柔軟なメタデータには**JSONB**を適切に使用しなければなりません。
-   **Action**:
    1.  **supa_audit拡張**: Supabaseの`supa_audit`拡張を使用して汎用的なテーブル監査を実装してください。`INSERT`/`UPDATE`/`DELETE`イベントを自動記録します。ただし、**高書き込みテーブル（3k ops/秒超）では監査を無効化**してください — 書き込みスループットが低下します。
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
    5.  **pg_jsonschema**: `pg_jsonschema`拡張でJSONBデータのバリデーションを実装してください。データ整合性を保証します。

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
-   **Law**: エンタープライズ向け**SAML 2.0 SSO**はCLI経由で設定し、モバイルアプリでは**Deep Linking**でAuth redirectを適切に処理しなければなりません。
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
-   **Law**: 既存データベースからSupabaseへの移行は**`pg_dump`/`pg_restore`**を使用し、移行手順をドキュメント化・再現可能にしなければなりません。
-   **Action**:
    1.  **スキーマエクスポート**: `supabase db dump`または`pg_dump`でスキーマとデータをエクスポートしてください:
        ```bash
        # スキーマのみ
        pg_dump --schema-only --no-owner --no-privileges \
          -d "postgresql://user:pass@host:5432/db" > schema.sql
        # データのみ
        pg_dump --data-only --no-owner \
          -d "postgresql://user:pass@host:5432/db" > data.sql
        ```
    2.  **インポート**: `psql`でSupabaseプロジェクトにインポートしてください:
        ```bash
        psql -d "postgresql://postgres:[password]@db.[ref].supabase.co:5432/postgres" \
          -f schema.sql
        psql -d "postgresql://postgres:[password]@db.[ref].supabase.co:5432/postgres" \
          -f data.sql
        ```
    3.  **注意事項**: ユーザー/ロール、RLSポリシーのステータスは`pg_dump`では移行されません。移行後に手動で再作成してください。
    4.  **大規模データ移行**: 100MB超のデータには`pgloader`を使用してください。MySQL/MS SQLからの移行にも対応します。
    5.  **CSVインポート**: 小規模データ（100MB未満）はダッシュボードのCSVインポート機能を使用してください。プログラマティックな場合はSupabase APIの`upsert`を使用しますが、**バルクインポートはRate Limiting対象**のため注意。

### Rule 40.2: The Seed Data Management Protocol
-   **Law**: 開発用の初期データは**`supabase/seed.sql`**で管理し、スキーマ定義とデータ投入を明確に分離しなければなりません。
-   **Action**:
    1.  **seed.sqlの配置**: `supabase/seed.sql`に初期データのINSERT文を記述してください。`supabase start`または`supabase db reset`時にマイグレーション後に自動実行されます。
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
-   **Law**: データ量がペタバイト規模に達する、または単一PostgreSQLインスタンスの垂直スケーリング限界に近づく場合は、Supabase **Multigres**（Vitessベースの水平シャーディング）の導入を計画しなければなりません。
-   **Action**:
    1.  **Phased Scaling**: Multigresは段階的なスケーリングを提供します:
        -   **Phase 1**: スマートコネクションプーリング（Supavisor統合）
        -   **Phase 2**: 高可用性（HA）とフェイルオーバー
        -   **Phase 3**: 完全なシャーディング（データ分散）
    2.  **Shard Key Design**: シャーディング導入時は、**テナントID**または**ユーザーID**をシャードキーとして設計してください。ランダムUUIDをシャードキーにすると、クロスシャードクエリが頻発しパフォーマンスが劣化します。
    3.  **Application Transparency**: Multigresはアプリケーション層からは透過的に動作します。既存の`supabase-js`コードの書き換えは不要ですが、クロスシャードJOINの回避を意識したスキーマ設計が必要です。
    4.  **Co-located Data**: 同一ユーザー/テナントのデータは同一シャードに配置（Co-location）してください。親子関係のあるテーブルは同一シャードキーを共有し、ローカルJOINを可能にします。
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
-   **Law**: PostgreSQL 18の**Asynchronous I/O（AIO）**サブシステム（`io_uring`ベース）の特性を理解し、I/O集約型ワークロードのパフォーマンス最適化に活用しなければなりません。
-   **Action**:
    1.  **Performance Awareness**: PostgreSQL 18のAIOは、シーケンシャルスキャンやVACUUMなどのI/O集約型操作で**2-3倍のスループット向上**を実現します。大規模なバッチ処理やデータ分析クエリで特に効果を発揮します。
    2.  **Linux Requirement**: `io_uring`はLinuxカーネル5.1以上で利用可能です。Supabaseマネージド環境では自動的に有効化されますが、セルフホスト環境ではカーネルバージョンを確認してください。
    3.  **Monitoring**: AIOの効果は`pg_stat_io`ビューで確認できます。I/O待ち時間の削減をモニタリングし、パフォーマンスベースラインを更新してください。

### Rule 42.2: The UUIDv7 Migration Protocol
-   **Law**: PostgreSQL 18のネイティブ`uuidv7()`関数を活用し、新規テーブルの主キーには**UUIDv7**（時間順序UUID）を採用しなければなりません。
-   **Action**:
    1.  **UUIDv7 Default**: 新規テーブルの主キーには`gen_random_uuid()`（UUIDv4）ではなく`uuidv7()`を使用してください:
        ```sql
        CREATE TABLE public.new_table (
          id UUID PRIMARY KEY DEFAULT uuidv7(),
          created_at TIMESTAMPTZ DEFAULT NOW()
        );
        ```
    2.  **B-tree Performance**: UUIDv7は時間ベースでソートされるため、B-treeインデックスのフラグメンテーションが大幅に削減されます。UUIDv4と比較してINSERTパフォーマンスが向上し、インデックスサイズも安定します。
    3.  **Migration Strategy**: 既存テーブルのUUIDv4をUUIDv7に移行する必要は**ありません**。新規テーブルからUUIDv7を採用し、段階的に移行してください。
    4.  **Backward Compatibility**: UUIDv7は標準のUUID型と完全に互換性があります。既存のFK制約やアプリケーションコードの変更は不要です。
-   **Rationale**: UUIDv4はランダム分布のため、B-treeインデックスのページ分割が頻発し、大規模テーブルでのINSERTパフォーマンスが劣化します。UUIDv7は時間クロノロジカルな分布によりこの問題を根本解決します。

### Rule 42.3: The B-tree Skip Scan Protocol
-   **Law**: PostgreSQL 18の**B-tree Skip Scan**最適化を活用し、複合インデックスの先頭カラムを指定しないクエリのパフォーマンスを改善しなければなりません。
-   **Action**:
    1.  **Skip Scan Awareness**: 複合インデックス`(a, b)`に対して`WHERE b = 'value'`のように後続カラムのみでフィルタする場合、PostgreSQL 18はSkip Scanを自動適用し、従来のSeq Scanを回避します。
    2.  **Index Design Impact**: Skip Scanの存在により、「先頭カラムの選択性」のみでインデックス順序を決定する従来の設計ルールが緩和されます。ただし、Skip Scanは先頭カラムのNDV（Number of Distinct Values）が小さい場合に最も効果的です。
    3.  **EXPLAIN Verification**: `EXPLAIN ANALYZE`でSkip Scanが適用されているか確認してください。`Index Only Scan`の`Skip`マーカーが表示されます。
-   **Rationale**: 従来のPostgreSQLでは複合インデックスの先頭カラムを指定しないクエリはインデックスを利用できませんでしたが、Skip Scanにより部分的なインデックス利用が可能になり、不必要な追加インデックスの作成を回避できます。

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
-   **Rationale**: Passkeysはフィッシング耐性があり、パスワード漏洩リスクを根本的に排除します。2025年以降、主要ブラウザとOS全てがPasskeysをサポートしており、パスワードレス認証の標準として採用が進んでいます。

---

## 45. MCP Server & AI開発統合戦略 (MCP Server & AI Development Integration Strategy)

### Rule 45.1: The Supabase MCP Server Protocol
-   **Law**: Supabase **MCP（Model Context Protocol）Server**を活用してAIコーディングアシスタント（Cursor, Claude, VS Code等）とSupabaseプロジェクトを安全に接続し、AI支援開発の効率を最大化しなければなりません。
-   **Action**:
    1.  **Remote MCP Server（推奨）**: 2025年10月以降のRemote MCP Serverを使用し、ローカルセットアップなしでAIツールからSupabaseプロジェクトを操作してください。セキュリティが強化されています。
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
-   **Law**: Supabase **Security Advisor**（AI支援セキュリティ診断）の警告を§0.1（Zero Tolerance Linter Protocol）と同等に扱い、全警告を即座に解決しなければなりません。
-   **Action**:
    1.  **Weekly Scan**: Security Advisorのスキャンを**週次**で実行し、新規警告の発生を即座に検知してください。CI/CDパイプラインに統合し、マージ前のチェックとして運用することを推奨します。
    2.  **Alert Categories**: 以下のカテゴリの警告に対して対応優先度を設定してください:
        -   **Critical（即時）**: RLS未有効テーブル、Service Roleキーのクライアント露出、`SECURITY DEFINER`のsearch_path未設定
        -   **High（24時間以内）**: 冗長Permissiveポリシー、auth関数のInitPlan未適用、`WITH CHECK (true)`の存在
        -   **Medium（1週間以内）**: 未使用インデックス、不要な拡張の有効化
    3.  **AI-Assisted Fix**: Security AdvisorのAI修正提案は参考として活用してください。ただし、提案されたSQLを**無検証で適用することは禁止**です。必ずRLSの影響範囲を確認してから適用してください。
    4.  **Baseline Maintenance**: 初回スキャン時の警告数をベースラインとして記録し、以降のスキャンで警告数が増加していないことを確認してください。
-   **Rationale**: Security Advisorは2025年のSupabaseアップデートで大幅に強化され、AI支援による修正提案が追加されました。人間のレビューと組み合わせることで、セキュリティ品質を継続的に維持するための強力なツールとなります。

---

## 47. テーブル別API制御 & Data API無効化戦略 (Per-Table API Control & Data API Disable Strategy)

### Rule 47.1: The Granular API Exposure Protocol
-   **Law**: Supabaseの**テーブル別API制御**機能（2025年新機能）を活用し、PostgREST Data APIへの公開を**テーブル単位で制御**しなければなりません。全テーブルを一律に公開するデフォルト設定を見直してください。
-   **Action**:
    1.  **Dashboard Toggle**: ダッシュボードの「Table Editor」から各テーブルのAPI公開をON/OFFで切り替えてください。内部テーブル（`audit_logs`, `system_config`, `job_queues`等）はAPI非公開にします。
    2.  **Default Deny**: 新規テーブル作成時は**API非公開をデフォルト**とし、明示的に公開が必要なテーブルのみAPI公開を有効化してください。§28（Data API Hardening）の原則を強化します。
    3.  **Data API Disable**: 内部ツール専用プロジェクトなど、公開APIが不要な場合は**Data API自体を完全無効化**してください（2025年新機能）。攻撃面のゼロ化が可能です。
    4.  **API Layer Architecture**: 全ての外部アクセスをEdge Functions経由に統一し、Data APIを無効化する「API Gateway Pattern」を推奨します:
        ```
        Client → Edge Functions（認証・バリデーション）→ Supabase DB（直接接続）
        ```
-   **Rationale**: PostgREST Data APIは開発の高速化に貢献しますが、全テーブルをAPI公開すると攻撃面が不必要に拡大します。テーブル別の制御により、必要最小限のAPI公開を実現し、§28の原則をより簡便に適用できます。

---

## 48. VPC & Private Link戦略 (VPC & Private Link Strategy)

### Rule 48.1: The Network Isolation Protocol
-   **Law**: 本番環境のデータベースは**ネットワークレベルの分離**を実施し、パブリックインターネットからの直接アクセスを最小化しなければなりません。
-   **Action**:
    1.  **AWS Private Link**: Enterprise/Teamプランでは**AWS PrivateLink**を設定し、VPC内からのプライベート接続を確立してください。パブリックインターネットを経由しないため、データ傍受リスクがゼロになります。
    2.  **IP Allow List**: ダッシュボードの「Network Restrictions」で、接続を許可するIPアドレス/CIDRレンジを設定してください。オフィスIPやCI/CDランナーのIPのみを許可し、それ以外からの接続を拒否します。
    3.  **SSL Enforcement**: データベース接続には**SSL/TLS暗号化を必須**としてください。Supabaseはデフォルトでこれを強制しますが、セルフホスト環境では明示的に設定が必要です。
    4.  **Bastion Host Pattern**: 開発者がプロダクションDBに直接アクセスする必要がある場合は、Bastion Host（踏み台サーバー）経由のSSHトンネルを設定してください。直接ポート公開は禁止です。
    5.  **Zero Trust**: ネットワーク分離はセキュリティレイヤーの1つに過ぎません。RLS（§3）、Column-Level Security（§43）、Data API Hardening（§28）と組み合わせた多層防御を維持してください。
-   **Rationale**: ネットワークレベルの分離は、アプリケーションレベルのセキュリティ（RLS等）とは独立した防御層です。万が一RLSに設定漏れがあっても、ネットワーク分離により外部からの攻撃を物理的に遮断できます。

---

## 49. Read Replicas & 負荷分散戦略 (Read Replicas & Load Balancing Strategy)

### Rule 49.1: The Read Replica Architecture Protocol
-   **Law**: 読み取り負荷が高いアプリケーションでは、**Read Replicas**（読み取り専用レプリカ）を配置し、プライマリDBの負荷を分散しなければなりません。
-   **Action**:
    1.  **Query Routing**: 読み取り専用クエリ（SELECT）はRead Replicaへルーティングし、書き込みクエリ（INSERT/UPDATE/DELETE）はプライマリへルーティングしてください。Supavisor（§23参照）がこのルーティングを自動管理します。
    2.  **Replication Lag Awareness**: 非同期レプリケーションでは数ミリ秒〜数秒のラグが発生します。「書き込み直後の読み取り」が必要な場合（例: 保存→即時画面更新）は、プライマリから直接読み取る**Read-Your-Writes**パターンを実装してください。
    3.  **Geo-distributed Replicas**: グローバルアプリケーションでは、エンドユーザーに近いリージョンにRead Replicaを配置し、読み取りレイテンシを最小化してください。
    4.  **Analytics Offloading**: 分析クエリ（集計、レポート生成等）は専用のRead Replicaにオフロードし、OLTP（通常のトランザクション処理）への影響をゼロにしてください。
    5.  **Monitoring**: レプリケーションラグを`pg_stat_replication`で監視し、ラグが閾値（例: 5秒）を超えた場合はアラートを発報してください。
-   **Rationale**: 単一のプライマリDBに全ての読み書きを集中させると、CPU/メモリの飽和によりレスポンスタイムが劣化します。Read Replicaにより読み取り性能を水平スケールし、プライマリの書き込み性能を保護します。

---

## 50. Project-scoped Roles & チーム管理戦略 (Project-scoped Roles & Team Management Strategy)

### Rule 50.1: The Project-scoped RBAC Protocol
-   **Law**: Supabaseの**Project-scoped Roles**（2025年新機能）を活用し、チームメンバーやCI/CDツールのアクセス権限を**プロジェクト単位で最小権限**に制限しなければなりません。
-   **Action**:
    1.  **Role Granularity**: 以下のロールを使い分けてください:
        -   **Owner**: プロジェクト設定、課金、メンバー管理。最小人数に限定。
        -   **Admin**: DB管理、マイグレーション、Edge Functions管理。テックリードに限定。
        -   **Developer**: 読み取り、ローカル開発。開発チーム全員。
        -   **Read-only**: ダッシュボード閲覧のみ。QA、マネージャー等。
    2.  **CI/CD Service Account**: GitHub ActionsなどのCI/CDパイプラインには**専用のService Account**を作成し、必要最小限の権限（マイグレーション実行、Edge Functionsデプロイ）のみを付与してください。個人アカウントのAPIキーをCI/CDに使用することは禁止です。
    3.  **Regular Audit**: 四半期ごとにプロジェクトメンバー一覧とロール割り当てを監査し、退職者・異動者のアクセス権を即座に取り消してください。
    4.  **MCP Integration**: AIコーディングツール（§45参照）にはDeveloper以下のロールのみを割り当て、スキーマ変更やデータ操作の直接実行を防止してください。
-   **Rationale**: 全メンバーにOwner権限を付与する「フラットアクセス」は、権限昇格攻撃や誤操作のリスクを最大化します。最小権限原則（PoLP）により、インシデント発生時の影響範囲を最小化します。

---

## 51. GitHub Actionsフル統合 CI/CD戦略 (GitHub Actions Full Integration CI/CD Strategy)

### Rule 51.1: The Supabase CI/CD Pipeline Protocol
-   **Law**: マイグレーション、テスト、Edge Functionsデプロイを**GitHub Actions**で完全自動化し、手動デプロイを排除しなければなりません。
-   **Action**:
    1.  **Pipeline Architecture**:
        ```yaml
        # .github/workflows/supabase-deploy.yml
        on: push: branches: [main]
        jobs:
          test:
            - supabase db start  # ローカルDB起動
            - supabase db reset  # マイグレーション適用
            - npm run test:db    # RLSテスト実行
          deploy-migrations:
            needs: test
            - supabase link --project-ref $PROJECT_ID
            - supabase db push   # マイグレーション適用
          deploy-functions:
            needs: test
            - supabase functions deploy
          type-gen:
            needs: deploy-migrations
            - supabase gen types typescript > src/types/database.types.ts
        ```
    2.  **Branch Preview**: PRごとにSupabase Branching（§20.2参照）でプレビュー環境を自動作成し、マイグレーションの動作確認を行ってください。
    3.  **Rollback Strategy**: マイグレーション失敗時の自動ロールバック手順を定義し、CIパイプラインに組み込んでください。§7.7（Expand-Contract）パターンの適用を推奨します。
    4.  **Secret Management**: Supabase APIキー、Service Roleキーは**GitHub Secrets**に格納し、ワークフローファイルへの直接記載を禁止します。
    5.  **Notification**: デプロイ成功/失敗をSlack/Discord等に通知し、チーム全体でデプロイ状況を可視化してください。
-   **Rationale**: 手動デプロイは「デプロイ忘れ」「環境差異」「手順ミス」の三重リスクを生みます。CI/CD自動化により、全環境で一貫したデプロイプロセスを保証し、人的エラーを構造的に排除します。

---

## 52. PostgreSQL Advisory Locks & 同時実行制御戦略 (PostgreSQL Advisory Locks & Concurrency Control Strategy)

### Rule 52.1: The Advisory Lock Architecture Protocol
-   **Law**: 排他的な処理（バッチジョブの二重実行防止、リソースの同時編集防止等）には、PostgreSQLの**Advisory Locks**を活用しなければなりません。
-   **Action**:
    1.  **Session vs Transaction Locks**: 用途に応じてロックの種類を選択してください:
        -   **Session Lock**（`pg_advisory_lock`）: セッション終了まで保持。長時間バッチジョブに使用。
        -   **Transaction Lock**（`pg_advisory_xact_lock`）: トランザクション内でのみ有効。短時間の排他処理に使用。
    2.  **Try Lock Pattern**: `pg_try_advisory_lock`で非ブロッキングなロック取得を行い、ロック取得失敗時は即座にスキップまたはリトライしてください。無限待機は禁止です。
    3.  **Lock Key Design**: ロックキーは`bigint`型です。テーブルOID + レコードIDの組み合わせで一意なキーを生成してください:
        ```sql
        SELECT pg_try_advisory_lock(
          'batch_jobs'::regclass::integer,
          hashtext('daily_report')
        );
        ```
    4.  **Deadlock Prevention**: 複数のAdvisory Lockを取得する場合は、常に同一の順序で取得してください。順序の不統一はデッドロックの原因です。
    5.  **Release Obligation**: Session Lockは必ず`pg_advisory_unlock`で明示的に解放してください。解放忘れはリソースリークです。
-   **Rationale**: アプリケーション層でのロック管理（Redis等）は追加のインフラ依存を生みます。PostgreSQLのAdvisory Locksを使用することで、DBと一体化した軽量な同時実行制御を実現し、外部依存を排除します。

---

## 53. Webhook Signature & イベント駆動統合戦略 (Webhook Signature & Event-Driven Integration Strategy)

### Rule 53.1: The Webhook Security Protocol
-   **Law**: 外部サービスとのWebhook連携においては、**署名検証（Signature Verification）**を必須とし、偽装リクエストを物理的に遮断しなければなりません。
-   **Action**:
    1.  **HMAC Verification**: Webhook受信側（Edge Functions等）では、リクエストヘッダーに含まれる署名を**HMAC-SHA256**で検証してください:
        ```typescript
        const signature = req.headers.get('x-webhook-signature');
        const expectedSig = createHmac('sha256', WEBHOOK_SECRET)
          .update(body).digest('hex');
        if (signature !== expectedSig) {
          return new Response('Unauthorized', { status: 401 });
        }
        ```
    2.  **Timestamp Validation**: リクエストのタイムスタンプが**5分以内**であることを検証し、リプレイ攻撃を防止してください。
    3.  **Idempotency Key**: Webhook処理には**冪等性キー**（`idempotency_key`）を使用し、同一イベントの二重処理を防止してください。受信済みキーをDBに記録し、重複をチェックします。
    4.  **Dead Letter Queue**: 処理失敗したWebhookイベントは**Dead Letter Queue**（pgmq等）に保存し、手動またはバッチで再処理可能にしてください。イベントの消失は許容しません。
    5.  **Schema Versioning**: Webhookペイロードにはバージョン番号（`v1`, `v2`等）を含め、スキーマ変更時の後方互換性を保証してください。
-   **Rationale**: 署名なしのWebhookは「誰でも偽リクエストを送信可能」な攻撃面です。署名検証により認証されたリクエストのみを処理し、データの整合性とセキュリティを保証します。

---

## 54. Database Partitioning高度戦略 (Advanced Database Partitioning Strategy)

### Rule 54.1: The Partitioning Decision Framework
-   **Law**: テーブルのレコード数が1,000万件（10M）を超える見込みの場合、または保持期間管理が必要な場合は、§2.13で定義したパーティショニング戦略を具体的に実装しなければなりません。
-   **Action**:
    1.  **Partition Type Selection**:

        | タイプ | キー例 | ユースケース |
        |:-------|:-------|:------------|
        | **Range** | `created_at` | ログ、トランザクション（月次分割） |
        | **List** | `tenant_id`, `region` | マルチテナント、地域分離 |
        | **Hash** | `user_id` | 均等分散が必要な大規模テーブル |

    2.  **pg_partman Integration**: `pg_partman`拡張を使用してパーティションの自動作成・保持期間管理を設定してください:
        ```sql
        SELECT partman.create_parent(
          p_parent_table := 'public.audit_logs',
          p_control := 'created_at',
          p_type := 'range',
          p_interval := '1 month',
          p_premake := 3
        );
        ```
    3.  **Partition Pruning**: クエリには必ずパーティションキー（`created_at`等）をWHERE句に含め、**Partition Pruning**（不要なパーティションのスキップ）をオプティマイザに有効化させてください。パーティションキーなしのクエリは全パーティションスキャンとなり、パーティショニングの意味がありません。
    4.  **Index Strategy**: 各パーティションにインデックスを個別に作成してください。グローバルインデックスはPostgreSQLでは利用できません。`CREATE INDEX ON ONLY parent_table`でテンプレートインデックスを定義し、新規パーティション作成時に自動適用されるようにしてください。
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
    3.  **Japanese Language Support**: 日本語全文検索には`pgroonga`拡張（§36参照）を推奨します。PostgreSQL標準の`japanese`辞書は形態素解析の精度が限定的です。
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
-   **Law**: DBスキーマからフロントエンドUIまで、**途切れることのない型安全チェーン**を構築しなければなりません。
-   **Action**:
    1.  **Layer 1 — DB Types**: `supabase gen types typescript`で自動生成された`database.types.ts`を**Single Source of Truth**とします。手動編集は§12.4に従い厳禁です。
    2.  **Layer 2 — Zod Validation**: APIバウンダリ（Server Actions、Edge Functions）ではZodスキーマでランタイムバリデーションを実行してください:
        ```typescript
        import { z } from 'zod';
        const CreatePostSchema = z.object({
          title: z.string().min(1).max(200),
          body: z.string().min(10),
          status: z.enum(['draft', 'public']),
        });
        type CreatePostInput = z.infer<typeof CreatePostSchema>;
        ```
    3.  **Layer 3 — DTO Mapping**: §0.2（Trinity DTO Mandate）に従い、DB型→DTO→コンポーネントPropsの変換チェーンを明示的に定義してください。各変換はMapped Typeで型安全に実装します。
    4.  **Layer 4 — Type Synchronization**: CI/CDパイプライン（§51参照）に型生成ステップを組み込み、スキーマ変更時に型定義が自動更新されることを保証してください。
    5.  **Type Gap Detection**: `tsc --noEmit`をCIに必須チェックとして組み込み、型エラーがマージされることを物理的に防止してください。
-   **Rationale**: 型安全チェーンの途切れ（Any型の乱用、手動型定義のドリフト）は、ランタイムエラーの最大の原因です。DBからUIまでの完全な型安全により、コンパイル時にバグを検出します。

---

## 58. グローバルCDN & Edge Caching戦略 (Global CDN & Edge Caching Strategy)

### Rule 58.1: The Edge Caching Architecture Protocol
-   **Law**: パブリックコンテンツの配信には**Edge Caching**を最大限活用し、オリジンサーバー（Supabase）への不必要なリクエストを削減しなければなりません。
-   **Action**:
    1.  **Cache-Control Headers**: バケット・エンドポイントごとに適切な`Cache-Control`ヘッダーを設定してください:

        | コンテンツタイプ | Cache-Control | TTL |
        |:---------------|:-------------|:----|
        | 静的アセット（CSS/JS/Fonts） | `public, max-age=31536000, immutable` | 1年 |
        | 公開画像 | `public, max-age=86400, s-maxage=604800` | CDN: 7日, Browser: 1日 |
        | API応答（公開データ） | `public, s-maxage=60, stale-while-revalidate=30` | CDN: 60秒 + SWR |
        | 認証必須データ | `private, no-store` | キャッシュ不可 |

    2.  **Stale-While-Revalidate**: 公開APIエンドポイントには`stale-while-revalidate`ディレクティブを活用し、キャッシュ更新中も古いデータを返すことでユーザー体験を維持してください。
    3.  **Cache Invalidation**: コンテンツ更新時はCDNのキャッシュを明示的にパージするか、URLにバージョンパラメータ（`?v=hash`）を付与してキャッシュバスティングを実行してください。
    4.  **Cloudflare Integration**: §1（Hybrid Stack）で定義したCloudflare CDNとSupabase Storageの統合を最適化し、画像変換（§6.2）のキャッシュヒット率を最大化してください。
-   **Rationale**: CDNキャッシュなしでは全リクエストがオリジンに到達し、Supabaseのコンピュート・ネットワーク使用量が不必要に増大します。適切なキャッシュ戦略により、コスト削減とレスポンス高速化を同時に実現します。

---

## 59. コンプライアンス & データ主権戦略 (Compliance & Data Sovereignty Strategy)

### Rule 59.1: The Regulatory Compliance Framework
-   **Law**: プロジェクトが対象とする法域の**データ保護規制**（GDPR, APPI, CCPA, SOC2等）を特定し、Supabase環境での技術的遵守措置を実装しなければなりません。
-   **Action**:
    1.  **Data Classification**: 全データを以下のカテゴリに分類し、取り扱い基準を定義してください:

        | 分類 | 例 | 暗号化 | 保持期間 | アクセス制御 |
        |:-----|:---|:-------|:---------|:-----------|
        | **最高機密** | 決済情報、マイナンバー | Vault暗号化必須 | 法定最短 | Service Role + 監査ログ |
        | **機密** | メールアドレス、電話番号 | 転送時暗号化 | 退会後90日 | RLS + CLS |
        | **社内限定** | 管理メモ、内部評価 | 転送時暗号化 | 無期限 | RLS（管理者のみ） |
        | **公開** | 店舗名、公開レビュー | 不要 | 無期限 | `USING (true)` |

    2.  **Region Selection**: PIIを保持するSupabaseプロジェクトは、対象法域に対応するリージョンを選択してください（例: 日本のAPPI → `ap-northeast-1`）。§11.1（Data Residency Protocol）と連携します。
    3.  **DSAR Automation**: データ主体アクセス要求（DSAR: Data Subject Access Request）に24時間以内に応答できるよう、ユーザーデータのエクスポート・削除を自動化するRPC関数を用意してください。
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
    1.  **Quarterly Assessment**: 四半期ごとにチームでマチュリティ評価を実施し、改善計画を策定してください。
    2.  **L3 Target**: 新規プロジェクトは**L3（Defined）**到達を初期目標としてください。L3未満での本番リリースは原則禁止です。
    3.  **Gap Analysis**: 現在のレベルと目標レベルのギャップを特定し、本ドキュメントの該当セクションを参照して段階的に改善してください。
-   **Rationale**: 成熟度モデルは「何を改善すべきか」の優先順位を明確にし、闇雲なルール適用を防ぎます。段階的なアプローチにより、チームの負荷を適切に管理しながら運用品質を向上させます。

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
| **CI/CD / GitHub Actions** | §51 |
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
-   **管理者権限**: §11.6 / §12.1（Service Role）→ §3.0.2（Admin RLS Mandate）→ §12.7（Client Identity Audit）→ §50（Project-scoped Roles）
-   **認証セキュリティ**: §5（Auth基礎）→ §5.1（RLS by Default）→ §5.2（Session管理）→ §18.1（APIキー）→ §18.2（PKCE/MFA）→ §44（Passkeys）→ §33（Auth Hooks）→ §35（SSR統合）→ §39（Social Auth）
-   **ストレージ**: §6（基礎）→ §6.1（S3互換）→ §6.2（Image Transformations）→ §2.11（孤立ファイル防衛）→ §58（CDN/Edge Caching）
-   **パフォーマンス最適化**: §4（基礎）→ §42（PostgreSQL 18 AIO/UUIDv7）→ §49（Read Replicas）→ §54（Partitioning）→ §55（Full-Text Search）→ §41（Multigres）
-   **セキュリティ多層防御**: §3（RLS）→ §43（CLS）→ §48（VPC/Private Link）→ §47（API制御）→ §46（Security Advisor）→ §28（Data API Hardening）
-   **AI統合**: §17（pgvector/AI Search）→ §45（MCP Server）→ §56（AI SQL Governance）
-   **CI/CD完全自動化**: §7（Migration基礎）→ §51（GitHub Actions）→ §19（テスト）→ §20（Branching）→ §57（型安全E2E）
-   **コンプライアンス**: §11.1（Data Residency）→ §59（Compliance Framework）→ §2.18（Retention）→ §43（CLS）→ §26（Vault）
-   **運用成熟度**: §60（Maturity Model）→ 全セクション

### クロスリファレンス（他ルールファイル）

| セクション | 関連ルール |
|-----------|-----------|
| §3（RLS / セキュリティ） | `600_security_privacy`, `601_data_governance` |
| §5（認証） | `600_security_privacy` |
| §7（マイグレーション / CI/CD） | `300_engineering_standards`, `700_qa_testing` |
| §17（pgvector / AI検索） | `400_ai_engineering` |
| §19（テスト） | `700_qa_testing` |
| §28（Data API Hardening） | `301_api_integration` |
| §42（PostgreSQL 18） | `300_engineering_standards` |
| §59（コンプライアンス / データ主権） | `601_data_governance`, `603_ip_due_diligence` |
