# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

### Supreme Directive 3.0: The RLS Implementation Iron Rules
*   **Law 1: Atomic Action Definition**
    *   `FOR INSERT, UPDATE` のようなカンマ区切り定義は禁止。`FOR ALL` 以外は、必ず**アクションごとに個別のポリシー**として定義してください。
*   **Law 2: INSERT Syntax Discipline**
    *   `INSERT` ポリシーは必ず **`WITH CHECK`** を使用してください（`USING` は不可）。
*   **Law 3: Zero Guessing Protocol**
    *   SQL作成前には必ずスキーマ定義ファイルを読み込み、**カラム名を指差し確認**してください。推測による実装は厳禁です。
*   **Law 4: Performance Safety (Scalar Subquery Mandate)**
    *   **Law**: `auth.uid()` や `current_setting()` などの関数呼び出し、およびポリシー内での他テーブル参照は、必ず **`(select auth.uid())`** 形式のスカラーサブクエリでラップし、評価の固定（Plan Dynamic InitPlan化）を強制してください。
    *   **Reason**: ラップしない場合、Postgres 行ごとにその関数を再評価（N+1評価）し、データ量が増加した際に CPU 使用率のスパイクとクエリ遅延を招く「隠れた爆弾」となります。

### Rule 3.0.1: The RLS Helper Functions Registry (RLS Utility)
*   **Security Definer Isolation**: RLS ポリシー内で自分自身（テーブル）を参照すると無限再帰（`42P17`）が発生します。admin 判定等の複雑なチェックは必ず `SECURITY DEFINER` 関数で分離してください。
*   **The Qualified Schema Mandate (RPC Security)**:
    *   **Law**: `SECURITY DEFINER` 関数内で `SET search_path = ''` を適用する場合、`public` スキーマの修飾がないテーブル参照は全てエラーとなります。
    *   **Action**: 関数内部では一文字の妥協もなく `public.profiles`、`public.reviews` と記述することを義務付けます。これを怠ることはシステムの「可用性の破壊」です。
    *   **Registry Standards**:
        *   `public.is_admin()`: 管理者チェック。
        *   `public.is_owner(resource_id)`: 所有者チェック。
        *   **Requirement**: ヘルパー関数は必ず **`SECURITY DEFINER`** 属性を付与し、かつ **`SET search_path = ''`** で検索パスを物理的に断ち切ってください。これにより、関数内部でのテーブル・関数参照は全てスキーマ修飾（例: `public.table_name`）を義務付け、Search Path 汚染によるインジェクション攻撃を物理的に不可能なレベルで排除します。

### Rule 3.0.2: The Admin RLS Mandate (The "Locked Out" Lesson)
*   **Context**: 「一般ユーザー権限」だけのポリシー（例: `user_id = auth.uid()`のみ）を書くと、管理者がそのテーブルを操作できなくなり、データ修正作業で詰みます。
*   **Law**: 全てのRLSポリシーにおいて、**「管理者は常にアクセス可能」** という例外条項を含めることを義務付けます。
*   **Pattern**:
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
*   **Admin Only Write (Strict Lock)**:
    ```sql
    -- "admins_only_insert_policy"
    FOR INSERT WITH CHECK (
      EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = (select auth.uid()) AND role IN ('admin', 'super_admin')
      )
    );
    ```
*   **User Restricted (Owners - Time Limited)**:
    ```sql
    -- "users_update_own_posts_policy"
    FOR UPDATE USING (
      user_id = (select auth.uid())      -- 本人のみ
      AND created_at > (now() - interval '1 hour') -- 作成後1時間以内のみ
    );
    ```
*   **Heirarchical Access (Parent Check)**:
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
*   **Separation Protocol**:
    1.  **Select Policy**: 読み取り権限は `FOR SELECT` 専用ポリシーで管理。
    2.  **Write Policy**: 書き込み権限は `FOR INSERT/UPDATE/DELETE` 専用ポリシーとし、**絶対に `SELECT` を含めてはなりません**。
*   **Admin Strictness**: 「管理者だから全部OK」の `FOR ALL` は原則禁止。

### Rule 3.2: Permissive Policy Consolidation
*   **Consolidation**: 「Admin権限」と「一般参照権限」などは可能な限り1つのポリシー内に `OR` 条件で統合し、ポリシー総数を削減してください。
*   **Efficiency**: 重複するポリシー（例：「Public View」と「Everyone View」）は即削除。

### Rule 3.3: Data Integrity Patterns
*   **Soft Delete**: 主要データは `deleted_at` による論理削除とし、ユニーク制約には `WHERE deleted_at IS NULL` を付与。
*   **The Right to be Forgotten (Soft Delete Exception)**:
    *   **Context**: 原則は論理削除ですが、ユーザーからの明示的な「アカウント削除リクエスト」および GDPR/Apple 要件に対しては、物理削除または完全匿名化（PII抹消）を行う義務があります。
    *   **Action**: 退会処理においては `deleted_at` だけでなく、個人特定情報を物理的に削除するか、不可逆的にマスク (`deleted_user_xyz`) してください。
    *   **Atomic Update**: リッチテキストは `_json` (Editor), `content` (View), `search_text` (Search) の3カラムへ同時保存。
    *   **No SQL Replace**: JSON内の文字列置換をSQLで行うことは禁止。

### Rule 3.3.1: The CMS Triple Write Protocol (Search Consistency)
*   **Context**: CMSコンテンツ（店舗名、記事タイトル等）は、「表示用」「編集用」「検索用」で要件が異なります。
*   **Law**: 重要なテキストデータは、1つのカラムに統合するのではなく、以下の3つの役割に分割して原子的に保存（Triple Write）することを標準とします。
    1.  **`name_display`**: 表示用（絵文字、装飾を含む）。
    2.  **`name_kana`**: ソートおよび読み仮名用（半角カナ等で正規化）。
    3.  **`name_search`**: 全文検索用（n-gramトークン化、または検索用メタデータ）。
*   **Automated Sync**: これらはフロントエンドからの送信時に同期させるか、可能であればDBトリガーで自動生成し、不整合（名前を変えたのに検索できない等）を物理的に防いでください。

### Rule 3.3.2: The Multiple Permissive Policies Conflict (Policy Hygiene)
*   **Law**: 同一テーブル、同一アクション（例: `SELECT`）に対して、複数の `PERMISSIVE` ポリシーが存在する場合、Postgres はそれらを `OR` で結合します。これは意図しないアクセス許可（穴）を生む原因となります。
*   **Action**: 新しいポリシーを追加する際は、必ず既存のポリシーを `DROP` するか、または「1つの統合されたポリシー」に整理してください。「適当に新しいのを追加して動いたからOK」という態度は、セキュリティエンジニアとして失格です。
*   **Verification**: `select * from pg_policies where tablename = '...';` で、意図した数（通常はアクションごとに1つ）であることを物理的に目視確認する義務があります。

### Rule 3.4: RLS Lifecycle Management Protocol
*   **Create-Verify-Drop Trinity (作成・検証・削除の三位一体)**:
    1.  **Before Create**: 新ポリシー追加前は必ず `SELECT policyname FROM pg_policies WHERE tablename = '...'` で現状を把握せよ。
    2.  **After Apply**: マイグレーション適用後、Dashboard の `Security Advisor` で `multiple_permissive_policies` が 0 件であることを物理的に確認せよ。
    3.  **Cleanup**: 重複したポリシー（Same Action, Same Table）が発見された場合、標準命名規則に従ったものを残し、他は **`DROP POLICY IF EXISTS "..." ON ...;`** で原子的に（同一マイグレーション内で）削除せよ。
*   **Naming Convention**: `"Public can view..."` 等の自然言語による命名を禁止します。**`tablename_action_policy`** 形式（例: `posts_select_policy`）での完全統一を義務付けます。
*   **Atomic Migration**: 新ポリシー作成と旧ポリシー削除は、常に**同一マイグレーションファイル**で原子的に実行してください。不整合期間が 1 ミリ秒でも存在することを許しません。
*   **Incident Prevention Checklist**:
    - [ ] 既存ポリシー一覧を確認したか？
    - [ ] 命名規則に従っているか？
    - [ ] レガシーポリシーの `DROP` を同一マイグレーションに含めているか？
    - [ ] `DROP POLICY` の名称は推測ではなく、DB上の実名と完全一致しているか？
    - [ ] **The Copy-Paste Mandate**: ポリシー名を手入力（タイピング）したか？ → YESならReject。必ずDashboard/SQLからコピペせよ。一字一句の不一致も許されない（Exact Policy Name Match Protocol）。
    - [ ] デプロイ後に Security Advisor 警告数を確認したか？
*   **Strictification Drop Mandate（厳格化時のDROP義務）**:
    *   **Warning**: RLSポリシーは**加算（OR）方式**で評価されます。既存のPermissiveポリシー（例: `USING (true)` の「誰でもOK」ルール）が残ったまま厳格なポリシーを追加しても、既存の緩いポリシーが優先され**新しいポリシーは実質無効化**されます。
    *   **Action**: セキュリティ強化マイグレーションでは、新しい厳格ポリシーを作成する**前に**、必ず `DROP POLICY IF EXISTS "旧ポリシー名" ON ...;` を実行し、既存の穴を物理的に塞いでください。
    *   **Template**:
        ```sql
        -- Step 1: 既存の緩いポリシーをDROP（必須）
        DROP POLICY IF EXISTS "legacy_permissive_policy" ON public.target_table;
        -- Step 2: 新しい厳格ポリシーを作成
        CREATE POLICY "target_table_select_policy" ON public.target_table
        FOR SELECT USING (strict_condition);
        ```
