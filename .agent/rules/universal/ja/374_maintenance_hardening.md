# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

## 8. 保守と堅牢化 (Maintenance & Hardening)

### Rule 8.1: Security Hardening (The Fortress)
*   **Public Schema Guard**: `REVOKE CREATE ON SCHEMA public FROM PUBLIC;` を実行。
*   **View Security**: `security_invoker = true` を設定。
*   **Search Path Defense (The Qualified Schema Mandate)**:
    *   **Law**: `SECURITY DEFINER` 関数には原則として `SET search_path = ''` (空) を設定し、検索パスへの依存を物理的に断ち切ってください。
    *   **Action**: 関数内では全てのテーブル参照を `public.users` のように**スキーマ完全修飾**で記述することを義務付けます。`SET search_path = public` は妥協であり、エイリアス攻撃のリスクを残します。

### Rule 8.2: The Audit Log Mandate / WORM
*   DB変更操作は `audit_logs` に記録し、テーブルは **Append-Only (追記のみ)** としてRLSで改竄を防止します。

### Rule 8.3: The Comprehensive RLS Audit
*   **Cascading Verification**: 重要テーブル（ナビゲーション、設定等）のRLS変更時は、**匿名ユーザー（ログイン前）** でのアクセス確認を義務付けます。
*   **Monthly Audit Mandate**: 月次でRLSポリシーの完全監査を実施すること。監査チェックリスト:
    - [ ] 全RLS有効テーブルでSELECT/INSERT/UPDATE/DELETEの各アクションにポリシーが存在するか
    - [ ] 管理者アクセス（`role IN ('admin', 'super_admin')`）が網羅的に設定されているか（管理者もロックアウトされていないか）
    - [ ] 一般ユーザーは自分のデータのみ閲覧・操作可能か
    - [ ] `(select auth.uid())` でスカラーサブクエリとしてラップされているか（Scalar Subquery Mandate）

### Rule 8.4: RLS Post-Change Verification Protocol
*   **Verification Scope**: RLSポリシー変更後は以下を必ず確認:
    1.  **Security Advisor**: 警告数がゼロであること。
    2.  **Functional Test**: 管理者、一般ユーザー、匿名ユーザーの各視点でデータアクセスを検証。
    3.  **Performance**: `EXPLAIN ANALYZE` でクエリプランに意図しないシーケンシャルスキャンがないこと。
*   **Critical Tables Checklist** (RLS変更後に必ず検証):
    - [ ] ナビゲーション系: `navigation_menus`, `navigation_items`
    - [ ] サイト設定系: `site_settings`, `system_settings`
    - [ ] 公開コンテンツ系: 店舗、投稿、レビュー等
    - [ ] マスタデータ系: エリア、カテゴリ等
*   **Pre-Deployment Smoke Test**:
    - [ ] トップページ (`/`) - ナビゲーション表示
    - [ ] ログインページ (`/login`) - フォーム表示
    - [ ] 一覧ページ - データ取得
*   **Emergency Recovery**: 障害発生時は影響テーブルに `FOR SELECT USING (true)` を即座に追加し、原因マイグレーションを特定して修正。
*   **Detection Symptoms (障害兆候)**:
    *   管理画面で「データがありません」だがDBには存在する。
    *   APIが403/404を返すがログには正常アクセスと記録される。
    *   本番のみデータが表示されない（開発環境との差異）。

---

## 9. ドメインデータモデリング (Domain Data Modeling)

### Rule 9.1: Universal Settings & Tenant-Aware Naming
*   **Strict Column Enforced**: アプリケーション設定値はRDBの正規化されたカラムとして定義。`jsonb` を設定ファイル代わりに使うことは型安全性の観点から禁止します。
*   **Tenant-Aware Naming (SaaS Readiness)**: 
    *   **Law**: 将来的なマルチテナント化（Whitelabel化）を見据え、内部リソース命名を区別してください。
    *   **Action**: 顧客（テナント）ごとの設定には `site_` や `account_` を、全テナント共通の基盤設定にのみ `system_` を使用します。これにより `tenant_id` 追加時の設計破綻を物理的に防ぎます。

### Rule 9.2: Static Page Ban (CMS Sovereignty)
*   利用規約やプライバシーポリシー等は **Headless CMS** で管理し、ハードコードされた静的ファイルを作成することを禁止します。

### Rule 9.3: Structural Integrity Protocols
*   **Structured Tagging**: 特徴データは `tags` テーブルで一元管理。
*   **Business Hours**: 営業時間は構造化データ(JSONB)とし、祝日設定を優先するロジックを標準化。
*   **Reputation System**: 評価スコアには単純平均ではなく **ベイジアン平均** を採用し、信頼性を担保。
*   **Geo-Centric**: 物理拠点には `latitude`/`longitude` を付与し、位置情報検索に対応。

---

## 10. 全球相互運用性 (Universal Portability)
*   **Ecosystem Portability**: 本プロジェクトのデータは、将来的に他システムや公的機関と連携される「デジタル資産」です。業界標準のスキーマ、メタデータ（Origin, Expiry）を採用し、エコシステム全体で通用する設計を維持してください。

---
