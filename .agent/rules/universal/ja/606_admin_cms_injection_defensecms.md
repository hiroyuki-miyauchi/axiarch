# 60. セキュリティとプライバシー (Security & Privacy - CISO & Legal View)

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> セキュリティと法的コンプライアンスは、Google Antigravityにおける**最上位の優先事項**です。
> ユーザーの利便性、開発速度、収益性、これら全てよりも優先されます。議論の余地はありません。

> [!CRITICAL]
> **Supreme Directive (最高指令)**
> 個人情報保護とセキュリティは、機能要件・納期・コストよりも常に優先されます。
> 本ドキュメントの内容に違反するコードは、いかなる理由があっても本番環境へデプロイしてはなりません。
>
> **The Zero Tolerance Protocol**:
> リスクに気づいた時点で、その大小や発生確率に関わらず、**例外なく・即座に・徹底的に** 対応してください。信用こそが最大の資産であり、それを損なう可能性のある事象を放置することは事業への背信行為です。

### 9.13. The Admin CMS Injection Defense（管理画面CMS注入防御）
*   **Law**: 管理画面からサイト全体の `<head>` やテンプレートに任意のHTML/スクリプトを埋め込める機能（カスタムヘッド、カスタムCSS、ウィジェット埋め込み等）は、強力なXSSベクタとなります。管理者アカウントが侵害された場合、サイト全体が汚染されるリスクがあります。
*   **Action**:
    1.  **Super Admin Only**: このような機能の編集・保存は、通常の管理者ではなく**最上位権限（System Admin / Super Admin）**を持つユーザーにのみ制限してください。
    2.  **Script Tag Warning**: 入力値に `<script>` タグや `javascript:` URI、`on*` イベントハンドラが含まれる場合、保存前にUI上で明示的な警告ダイアログを表示してください。
    3.  **Change Audit**: これらの変更は必ず監査ログに記録し、変更前後の差分を保持してください。
*   **Rationale**: 管理画面からの任意コード注入は、CSPを正しく設定していても管理者権限経由でバイパスされる可能性があるため、権限レベルでの防御と注入検知の二重防衛が必要です。

    *   **Official Link**: `supabase link` を使用し、Connection Pooler等の適切な経路を確立してください。（詳細は `37_backend_supabase.md` の Rule 7.2 を参照）
*   **The Iron Fortress Mandate**: 我々が維持するのは、ただのアプリではなく「城塞」です。
    1.  **Zero Warning Enforcement**: Security Advisor / Performance Advisor の警告（Warning/Error）が1件でも発生している状態でのプルリクエストは、自動的に **Reject** されます。
    2.  **No "True"**: RLSポリシーにおける `USING (true)` および `WITH CHECK (true)` は、いかなる理由があっても記述してはなりません。必ず `TO service_role` を付与するか、厳格な条件式を記述してください。
    3.  **No "No Policy"**: `RLS Enabled` かつポリシーが存在しない状態（INFO警告）は断じて許されません。
    4.  **Admin Lock**: 管理者専用テーブルは `role = 'admin'` 等で鉄壁に守ってください。
*   **Strategic Exception (Info Acceptance)**: `unused_index` 等の「Info（情報）」レベルに限り、意図的な設計であれば許容（Accepted）しますが、警告を消すために必要なインデックスを削除する「過剰防衛」は禁止します。
