# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

### 13.11. The Legal Hardcoding Ban (DB SSOT)
*   **Law**: 利用規約、プライバシーポリシー、特定商取引法に基づく表記などの法的テキストをソースコードに直書き（Hardcoding）することは禁止です。
*   **Action**:
    *   **DB First**: これらは必ず `site_settings` テーブルのカラムとして定義し、管理画面から非エンジニアが即座に修正可能な状態にしてください。
    *   **Risk**: 法改正時にエンジニアのデプロイを待つタイムラグは、コンプライアンス違反のリスクとなります。

### 13.12. The Audit Bypass Anti-Pattern (Server Action Mandate)
*   **Law**: クライアントサイド（`supabase-js` 等）から直接データベースの書き込み（INSERT/UPDATE/DELETE）を行うことは、サーバーサイドで制御される「監査ログ（Audit Logs）」をバイパスしてしまい、ガバナンス違反となります。
*   **Action**: 管理画面等における全てのデータ更新処理は、必ず `Server Actions` を経由させ、その内部で `recordAuditLog` を呼び出してください。直接的な DB 操作は厳禁です。

### 13.13. The Async Boundary Protocol (Client-Server Wall)
*   **Law**: Client Component (`'use client'`) から、非同期関数（`async function`）として定義された Server Component を直接インポートしてコンポーネントとして使用することは、React の仕様違反（Promise Serialization Error）です。
*   **Action**: Server Component を Client Component の子として配置する場合は、必ず **`children` Prop** として渡すか、Server Component 側でデータをフェッチして Props として渡すパターン（Composition）を使用してください。

### 13.14. The Dead Code Elimination Protocol (Garbage Prohibition)
*   **Law**: 「いつか使うかもしれない」「念のため残しておく」コードやコメントアウトされた死んだコードは、プロジェクトの認知負荷を増大させ、バグの温床となる「ゴミ（Garbage）」です。
*   **Action**:
    *   **No Mercy**: 新機能への移行が完了した、または不要と判断されたコードは、即座に**物理削除**してください。
    *   **Git Trust**: Gitの履歴がある限り、必要な時に復元可能です。コードベースに「墓標」を残してはいけません。
    *   **Ghost Feature Elimination**: ユーザー導線（UI）やAPIエンドポイントが存在しない未使用の機能コードは、発見次第削除し、Implementation Planとの同期を徹底してください。

### 13.15. The Select Specification Pattern (データ取得の明示化)
*   **Law**: ORM、Query Builder、またはDB直接呼び出しにおいて、`SELECT *` や `.select('*')` のような「全カラム取得」を禁止します。
*   **Reason**:
    1.  **Security**: 将来追加される機密カラム（`internal_memo`, `password_hash` 等）が意図せずクライアントに漏洩するリスク。
    2.  **Performance**: 不要なカラムの転送はネットワーク帯域とメモリを浪費する。
    3.  **AI Economy**: AIエージェントに不要なデータを読ませるとトークンを浪費し、推論精度が低下する。
*   **Action**:
    *   **Explicit Select**: 必要なカラムのみを明示的に列挙してください（例: `.select('id, name, status, created_at')`）。
    *   **Purpose-Driven Spec**: 用途別（一覧表示用、詳細表示用、管理者用）にSelect仕様を定義し、過不足なくデータを取得してください。
    *   **Registry**: プロジェクト規模に応じて、Select仕様を定数として一元管理（Select Spec Registry）し、散在・重複を防ぐことを推奨します。

### 13.16. The Type Lying Prohibition Protocol (型詐称の禁止)
*   **Law**: 型システムを欺く行為は、コンパイラとレビュワーの信頼を裏切る最大の犯罪です。以下の行為を禁止します。
    *   `as any` / `as never`: 型エラーの握りつぶし。
    *   `@ts-ignore` / `@ts-expect-error`（理由なし）: 型チェックの無効化。
    *   `eslint-disable`（理由なし）: Lintルールの恣意的な無効化。
*   **Exception**: やむを得ず使用する場合は、必ず以下を満たすこと。
    1.  **Reason**: なぜ型が合わないかの根本原因を1行コメントで記述。
    2.  **Ticket**: 対応するIssue番号を併記（例: `// TODO(#456): Fix after library update`）。
    3.  **Scope**: 影響範囲を最小限に限定（ファイル全体ではなく行単位）。
*   **Outcome**: 「ビルドが通る」と「型が安全」は別物です。前者のみで安心することは自殺行為です。

### 13.17. The No Future-Use Code Protocol (YAGNI 厳格化)
*   **Law**: 「将来使うかもしれない」コード、変数、インポート、関数は、現時点で使用されていない限り「ノイズ」であり、即時削除の対象です。
*   **Action**:
    *   **Unused Imports**: 未使用のインポートは1行たりとも残しません。Linter（`no-unused-vars`）を `error` レベルで強制してください。
    *   **Unused Variables**: `_` プレフィックスは「意図的に未使用である」ことを示す場合にのみ許可します（例: `const [_, setCount] = useState(0)`）。それ以外の未使用変数は物理削除してください。
    *   **Speculative Code**: 現在のユーザーストーリーに含まれない「先回り実装」は技術的負債です。必要になった時に書いてください。

### 13.18. The Service Layer Extraction Mandate (サービス層分離義務)
*   **Law**: Route Handler、Server Action、Controller 等のエントリーポイントは「薄いインターフェース」に徹しなければなりません。ビジネスロジック（バリデーション、DB操作、外部API呼び出し、計算）をエントリーポイントに直書きすることを禁止します。
*   **Action**:
    1.  **Service Layer**: ビジネスロジックは `lib/services/` または `lib/api/` に抽出し、テスト可能かつ再利用可能な状態にしてください。
    2.  **DTO Boundary**: Service 層の入出力は DTO（Data Transfer Object）で型安全に定義し、DB型やフレームワーク固有の型をUIに漏洩させないでください。
    3.  **Single Responsibility**: 1つの Service 関数は1つの責務のみを持ちます。「取得して加工して保存して通知する」関数は分割してください。
*   **Reason**: エントリーポイントにロジックが密結合すると、テスト不能、再利用不能、Omnichannel対応不能の三重苦を招きます。

### 13.19. The Clean Workspace Mandate (作業場清掃義務)
*   **Law**: タスク完了時、検証のために作成した一時ファイル（`test-*.ts`, `*.log`, `debug-*.ts`）やビルドキャッシュ（`*.tsbuildinfo`）は、**「使用後即廃棄」** を義務とします。
*   **Action**:
    *   **Scorched Earth**: 空ディレクトリ（`snapshots/`, `snippets/`）、残存する古いバックアップファイル、開発中にのみ使用した JSON ダンプは「過去の遺物」であり、リポジトリに残置したままコミットすることは禁止です。
    *   **Build Artifact**: `.tsbuildinfo`、`.next/cache` 等のビルドキャッシュは `.gitignore` で管理し、リポジトリに含めてはなりません。
    *   **Verification**: コミット前に `git status` で意図しないファイルが含まれていないことを確認してください。
*   **Rationale**: 不要なファイルの残置はコードベースのS/N比（Signal to Noise ratio）を低下させ、後続の開発者やAIエージェントの判断を誤らせます。

### 13.20. The CQRS Pattern (コマンドクエリ責務分離)
*   **Law**: Read操作とWrite操作が同一のService/Repositoryに混在することは、将来のスケーリング（Read Replica、キャッシュ最適化）の障壁となります。
*   **Action**:
    1.  **Read Layer (Query)**: データ取得専用の層を設け、Select Spec（明示的カラム指定）とキャッシュ戦略を必須引数とします。フィルタリング・ソート・ページネーションはこの層で提供してください。
    2.  **Write Layer (Command)**: データ変更専用の層を設け、全操作に監査ログの統合を推奨します。論理削除（Soft Delete）のサポートをオプションで設計してください。
    3.  **Cache Invalidation**: Write操作完了時に、関連するReadキャッシュを自動的に無効化する仕組み（タグベース等）を導入してください。
*   **Benefit**: Read/Writeの責務分離により、個別の最適化・スケーリング・テストが可能になります。

### 13.21. The DTO Synchronicity Protocol (DTO同期義務)
*   **Law**: Backend（Server Action/API）の戻り値をDTO化した場合、それを受け取るFrontend（UI Component/Form）のProps型も**必ず同一のDTOに同期**しなければなりません。
*   **Action**:
    1.  **Single Source**: DTO定義は `lib/dto/` 等に一元管理し、Backend・Frontendの両方からインポートしてください。
    2.  **No Drift**: BackendのDTO変更時は、それを参照する全てのFrontendコンポーネントのProps型も同時に更新してください。片方だけの更新は `undefined` 参照によるランタイムエラーの直接原因です。
    3.  **Type Guard**: DTO境界では必ず型ガード（`in` 演算子、`typeof`チェック）を行い、外部データの安全性を保証してください。
*   **Anti-Pattern**: BackendがDTO を返しているのにFrontendで `as any` にキャストして受け取ることは、DTOの意味を完全に無効化する「型の背信行為」です。
