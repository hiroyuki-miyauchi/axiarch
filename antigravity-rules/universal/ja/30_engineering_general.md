# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

## 1. コード品質とクリーンコード (Code Quality & Clean Code)

### 1.0. 至高の指令 (The Supreme Directive)
- **UI/Logic Consistency (完全統一)**:
  - **原則**: 「似ているが違う」はプロ意識の欠如であり、バグです。すべての機能（削除、編集、一覧）において、UIとロジックは統合されていなければなりません。
  - **Tiered Security**: セキュリティはリスクに応じて段階化します。
    - **Tier 1**: 一般的な単体操作は「確認のみ」とします。
    - **Tier 2**: 一括操作、および**ユーザー削除などの最重要単体操作**は「高セキュリティ認証（OTP/Passkey/2FA等）必須」とします。これを独自の判断で崩すことは許されません。
*   **クリーンコード基準 (Clean Code Standards)**:
    *   **自己文書化 (Self-Documenting)**: コメントは「Why（なぜ）」を語るために使い、「What（何をしているか）」はコード自身に語らせます。
    *   **関数サイズ (Function Size)**: 関数は「1つのこと」だけを行います。理想的には **20行以内** に収めます。
    *   **命名規則 (Naming)**: 変数名は具体的かつ明確にします。`data`, `temp`, `item` などの曖昧な名前は禁止です（例: `userData` -> `authenticatedUserProfile`）。
*   **Blueprint Compliance (憲法遵守)**:
    *   **Entry Point**: すべての開発作業は、まず `000_blueprint_index.md`（または対応するルールファイル）を確認することから始めます。
    *   **Update First**: 実装中に設計変更が必要になった場合、**コードを書く前に（または同時に）Blueprintを更新**します。ドキュメントとコードの乖離は最大の技術的負債です。
*   **警告ゼロ (Zero Warnings)**:
    *   **ルール**: 警告（Warning）はエラー（Error）として扱います。CIは警告が1つでもあれば失敗させます。「壊れた窓割れ理論」を防ぎます。
    *   **厳格なエラーハンドリング**: 空の `catch` ブロックは禁止です。全てのエラーはログに記録され、適切に処理されなければなりません。
*   **リファクタリング (Refactoring - The Boy Scout Rule)**:
    *   **義務 (Mandate)**: 「来た時よりも美しくして立ち去る（ボーイスカウトの精神）」。ファイルを触る際は、必ず小さな改善（命名変更、関数抽出）を行います。
    *   **「後で」はない (No "Later")**: 「後でリファクタリングする」は嘘です。今やるか、永遠にやらないかです。
    *   **複雑度の排除 (Cyclomatic Complexity)**: 複雑度（ネストの深さ）が高いコードは、バグの温床です。早期リターン（Early Return）を活用し、ネストを浅く保ちます。
*   **クリーンアップ (Cleanup)**:
    *   **デッドコードの即時削除**: コメントアウトされたコード、使われていないインポート、デバッグ用の `console.log` は、コミット前に完全に削除します。
    *   **TODOコメントの管理**: `// TODO:` を残す場合は、必ずチケット番号または期限を併記します。放置されたTODOは技術的負債です。

## 2. インフラとパフォーマンス (Infrastructure & Performance)
*   **インフラストラクチャ基準 (The Golden Quad)**:
    *   **Managed Hosting**: Vercel Pro等、DDoS保護とスケーラビリティを備えたマネージドホスティングを利用します。
    *   **BaaS**: Supabase等、DBとバックアップ機能が統合されたBaaSを「唯一の正解」として利用します。
    *   **Edge Shield**: Cloudflare等のエッジWAF/CDNを配置し、攻撃と負荷をエッジで吸収します。
    *   **Email Deliverability**: Resend等、開発者体験と到達率に優れたメールインフラを採用します。
*   **読み取り最適化 (Read-Optimized Architecture)**:
    *   **事前計算 (Pre-calculation)**: ランキング、集計、複雑なフィルタリング結果は、リクエストごと（On-the-fly）に計算せず、データ更新時または定期バッチで事前計算し、DBのカラム（例: `ranking_score`, `total_sales`）に保存します。
    *   **CQRS**: 参照系と更新系のモデルを分離し、参照系には非正規化（Denormalization）された読み取り専用テーブルやマテリアライズドビューの使用を推奨します。
    *   **The Hybrid CMS Design Strategy (Layout vs Content)**:
        *   **Context**: 並び替え順序や表示設定を正規化（RDB）すると、UI実装が複雑化しN+1を招きます。
        *   **Action**: 「レイアウト・順序」はJSON (`site_settings.sidebar_order`) で管理し、「コンテンツ」はRDBテーブル (`posts`) で管理するハイブリッド構成を標準とします。JSONの柔軟性とSQLの検索性を両立させます。
*   **パフォーマンス予算 (Performance Budgets)**:
    *   **Lighthouseスコア**: Performance, Accessibility, Best Practices, SEO の全てで **90点以上** を維持します（緑色）。
    *   **Core Web Vitals**: LCP (2.5s以内), FID (100ms以内), CLS (0.1以内) を厳守します。
*   **アセット最適化 (Asset Optimization)**:
    *   **画像 (Images)**: 次世代フォーマット（AVIF/WebP）を強制します。`next/image` 等の最適化コンポーネントを使用します。
    *   **遅延読み込み (Lazy Loading)**: ファーストビュー（Above the fold）以外の全てのアセットは遅延読み込みします。

## 3. 設計によるセキュリティ (Security by Design - DevSecOps)
*   **ゼロトラスト (Zero Trust)**:
    *   全ての入力（ユーザー入力、APIレスポンス）を疑います。バリデーションはクライアントとサーバーの両方で行います。
*   **機密情報管理 (Secrets Management)**:
    *   APIキーや秘密鍵はコードにコミットしません。`.env` ファイルとシークレットマネージャーを使用します。
    *   **The Single Source of Config**:
        *   **Prohibition**: コードの各所（コンポーネント内等）で直接 `process.env.NEXT_PUBLIC_...` を参照することは、変更時の修正漏れや型安全性の欠如を招くため禁止です。
        *   **Action**: 必ず `src/lib/config` (または `env.ts`) で一元管理し、アプリケーション全体からはその定数オブジェクトのみを参照してください。この層で存在チェック（Validation）を行うことを推奨します。

## 4. 技術的負債とクリーンアップ (Technical Debt & Cleanup)
*   **負債の返済 (Debt Paydown)**:
    *   スプリントの **20%** は技術的負債の返済（リファクタリング、ライブラリ更新）に充てます。
*   **テックレーダー (Tech Radar)**:
    *   **定期更新**: 依存ライブラリは四半期ごとに更新し、常に「安全な最先端（Bleeding Edge）」を維持します。
*   **デジタル5S (Digital 5S)**:
    *   **整理 (Seiri)**: 未使用のコード（Dead Code）、画像、ファイルは即座に削除します。コメントアウトされたコードを残しません。
    *   **The Ghost Feature Ban**: ユーザー導線が存在しない機能（公開されていない管理画面コード等）は負債です。YAGNI原則に従い、物理削除してください。

## 5. AIファースト開発 (AI-First Engineering)
*   **Prompt Driven Development (PDD)**:
    *   **原則**: コードは人間が書くものではなく、AIに書かせるものです。「プロンプト」こそが真のソースコードです。
    *   **AIフレンドリー**: 変数名や関数名は、AIが文脈を理解しやすいように、極めて記述的（Descriptive）にします（例: `x` ではなく `daysSinceLastLogin`）。
*   **RAG最適化 (RAG Optimization)**:
    *   **モジュール化**: ファイルサイズは小さく保ち（Atomic）、AIのコンテキストウィンドウを圧迫しないようにします。
    *   **Explicit Imports**: `import` ステートメントは必ずファイルの最上部（Top-Level）に記述してください。関数内や条件分岐内でのインポートは、静的解析を妨げ、AIの理解を困難にします。
    *   **セマンティック構造**: ディレクトリ構造は機能単位（Feature-based）で整理し、AIが関連ファイルを見つけやすくします。

## 6. グリーンコーディング (Green Coding & Sustainability)
*   **エネルギー効率 (Energy Efficiency)**:
    *   **アルゴリズム**: 計算量（O記法）を意識し、無駄なCPUサイクルを消費しないコードを書きます。これはバッテリー寿命と地球環境の両方を守ります。
    *   **ダークモード**: 有機EL（OLED）デバイスでの消費電力を抑えるため、真の黒（#000000）を使用したダークモードを推奨します。
*   **データ転送量**:
    *   **圧縮**: 画像や動画は必ず最適化（AVIF/H.265）し、ネットワーク帯域の浪費を防ぎます。
    *   **Cache Maximization**: CDNキャッシュヒット率 **80%以上** を目標とし、静的アセットのオリジン負荷を最小化します。
    *   **Centralized Storage Shield**: 画像実体はBaaSストレージ（Origin）に集約し、配信はCDNのOptimization機能を経由させることで、コストとパフォーマンスを両立します。

## 7. ゼロバグ・ポリシー (The "Zero Bug Policy")
*   **修正優先 (Fix First)**:
    *   既知のバグがある状態で新機能を開発しません。バグ修正は最優先事項です。
*   **24時間ルール (24-Hour Rule)**:
    *   クリティカルなバグ（データ損失、セキュリティ、主要機能停止）は、発見から **24時間以内** に修正します。

## 8. 継続的学習と検証 (Continuous Learning & Verification)
*   **最新情報の確認義務 (Latest Info Protocol)**:
    *   **開発着手前**: コードを書く前に、必ず対象技術の公式ドキュメントや最新のリリースノート（例: "Next.js 15 breaking changes", "Swift 6 concurrency"）を確認します。古い情報に基づいた実装は手戻りの元です。
    *   **非推奨チェック**: 使用しようとしているAPIが Deprecated（非推奨）になっていないか確認します。
*   **トレンドの把握**:
    *   シリコンバレーの最新トレンド（AIエージェント、Privacy Manifests等）を常にキャッチアップし、ルール自体も進化させ続けます。

## 9. 互換性とテスト (Compatibility & Testing)
*   **実機テスト (Real Device Testing)**:
    *   シミュレーターだけでなく、必ず実機（iOS, Android）でテストを行います。特にカメラ、GPS、生体認証などのハードウェア機能は実機必須です。
*   **ブラウザ互換性 (Browser Compatibility)**:
    *   Chrome, Safari (iOS/macOS), Firefox, Edge の最新2バージョンをサポートします。特にSafari（iOS）特有のバグ（100vh問題など）に注意します。
*   **セルフチェックリスト (Self-Check List)**:
    *   PRを出す前に、開発者は自身のコードをレビューし、「警告ゼロ」「コンソールエラーなし」「不要なログ削除」を確認します。
## 10. Gitとバージョン管理 (Git & Version Control)
*   **開発フロー (Trunk Based Development)**:
    *   **原則**: 長寿命のブランチは廃止し、短命のブランチから `main` へ頻繁に（毎日）マージします。
    *   **Stacked Diffs**: 巨大なPRを避け、依存関係のある小さなPRを積み重ねる手法を推奨します。
*   **コミットメッセージ (Conventional Commits)**:
    *   `type(scope): subject` 形式を厳守します（例: `feat(auth): add google login`）。本文には日本語で詳細を記述します。
    *   **Atomic Commits**: 1つのコミットには「1つの論理的変更」のみを含め、バグ発生時に「そのコミットだけ」をRevertすれば直る粒度を保ちます。
*   **プルリクエスト (Pull Requests)**:
    *   **100行ルール**: PRは小さく保ちます。
    *   **保護設定**: `main` への直接プッシュは禁止し、CI（Build, Test, Lint）通過とレビュー承認を必須とします。
    *   **Omnichannel Check**: レビュー時は「Web以外（iOS/Androidアプリ）でも利用可能か？」を最優先で確認します。"Web Only" のロジックは即座にRejectします。
    *   **Deployment Safety Protocol**:
    *   **Supreme Directive: The AI Git Ban**:
        *   **Law**: AIエージェントは、ユーザーからの明示的な指示（「コミットして」「Pushして」）がない限り、**一切のGitコマンド（add, commit, push, stash等）を実行してはなりません。**
        *   **Approval**: 作業完了時はファイルを保存するに留め、変更内容を提示してユーザーの判断を仰いでください。独断でのコミットは「ユーザーの確認機会を奪う」重大な憲法違反です。
        *   **Main Branch Sanctuary**: 現在のブランチが `main` の場合、いかなるコード編集も禁止します。必ず `feature/xxx` ブランチを作成してから作業を開始してください。
    *   **The Automated Deployment Mandate (CD First)**:
        *   **No Manual Deployment**: 本番環境へのデプロイ（DB変更含む）を、開発者の手動コマンド（`supabase db push` 等）で行うことは、オペミスと不整合の元凶であり**完全禁止**とします。
        *   **CI/CD Only**: デプロイは必ず「検証されたコード」が「信頼されたパイプライン（GitHub Actions）」を通過した結果としてのみ実行されなければなりません。ヒューマンエラーを排除します。
*   **セキュリティ**:
    *   APIキー等の機密情報は絶対にコミットせず、`.env` を使用します。CIでシークレットスキャン（TruffleHog）を義務付けます。
    *   **The Lockfile Integrity Protocol**:
        *   **Regeneration Reflex**: CIのみが失敗（Build/Lint error）する場合、原因の9割は `package-lock.json` の不整合です。調査に時間を使う前に、まず `rm -rf package-lock.json node_modules && npm install` を実行し、Lockfileを再生成してPushしてください。
        *   **Dependency Overrides**: React 19等の新バージョン対応で互換性エラーが出る場合、`legacy-peer-deps` で逃げるのではなく、`package.json` の `overrides` フィールドでバージョンを明示的に固定してください。これは依存関係を「管理下」に置くためのプロトコルです。

## 11. ドキュメント運用 (Documentation Ops)
*   **Living Documentation**:
    *   **Mermaid.js**: アーキテクチャ図は画像ではなくコード（Mermaid）で管理し、陳腐化を防ぎます。
    *   **ADR**: 技術的な意思決定は `docs/adr` にMarkdownで記録します。
*   **Docs as Code**:
    *   ドキュメントはコードと等価であり、Gitで管理し、PRレビューの対象とします。ドキュメント更新なきコード変更はマージ禁止です。
*   **鮮度維持**:
    *   リンク切れチェックを自動化し、主要ルールは四半期ごとに見直します。

## 12. エンジニアリング品質プロトコル (Engineering Quality Protocols)

### 11.1. The Zero-Warning Lint Protocol
*   **Law**: 「Warningなら無視しても動く」という甘えは品質低下の元です。CI全通過の真の意味は、警告数0です。
*   **Action**: `npm run lint` の結果は、必ず警告数0（Zero Warnings）でなければなりません。未使用変数は即座に削除してください。

### 11.2. The Clean Import Protocol
*   **Law**: `import` ステートメントは必ずファイルの最上部（Top-Level）に記述してください。
*   **Action**: 関数や制御フロー内でのインポートは厳禁です。どんなに急いでいても、インポートはファイルの先頭に移動させてください。

### 11.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: 開発者にとっての「常識」はユーザーにとっての「謎の記号」です。
*   **Action**: 管理画面上の専門用語・指標には、必ず `Tooltip` を付与し、「それが何であり、ビジネスにどう影響するか」を素人でも分かる言葉で解説してください。

### 11.4. Localization First Protocol
*   **Action**: エラーメッセージやバリデーションメッセージは、全て（Zodカスタムエラー等も含め）日本語化してください。

## 13. 高度アーキテクチャ原則 (Advanced Architectural Mandates)

### 13.1. The Trinity DTO Mandate (Constitutional Pillar)
*   **Law**: いかなる機能実装においても、以下の3点を遵守しないコードは、存在自体が憲法違反（Unconstitutional）となり、即時削除の対象となります。
    1.  **Security (PII Defense)**: 生データ（Raw Row）の出力は禁止です。必ず **DTO (White-list)** を経由し、機密情報を物理的に遮断してください。
    2.  **Stability (Frontend Shield)**: DBスキーマとUIを直結させてはなりません。Mapper関数という「防波堤」を築き、変更の影響をサーバー内で吸収してください。
    3.  **AI Economy (Token Optimization)**: AIに無駄なデータを読ませてはなりません。**AI-Optimized DTO** でトークンを極限まで節約し、推論精度を高めてください。
*   **Detailed Action**:
    *   **Strict Segregation**: 機密性の高いフィールドを含むDTOは、必ず `AdminDTO` / `PublicDTO` のように型レベルで物理的に分離してください。
    *   **No Raw Return**: Server ActionsやAPIは、生の `Database['public']['Tables']` 型を返してはなりません。必ず明示的に定義されたDTO型を返してください。
    *   **The Return Type Clarity Protocol (Wrapper Ban)**:
        *   **Law**: Server Actionsの戻り値型において、成功時に `{ data: T[] }` のような無意味なラッパーオブジェクトを使用することを禁止します。
        *   **Standard**: 成功時は `T` または `T[]` を直接返し、エラー時は `throw` または `null` を返すパターンに統一してください。呼び出し側での `res.data` アクセスによる混乱（undefined参照）を防ぎます。

### 13.1.x. The Client DB Access Prohibition (Architecture Law)
*   **Law**: クライアントサイド（React Components）から `supabase.from()` を直接呼び出すことは、RLSポリシーの実装漏れや生データ漏洩（DTO未適用）を招くため、アーキテクチャレベルで禁止します。
*   **Action**:
    *   **Gateway First**: データ取得・更新は必ず `Server Actions` または `Route Handler` (API) を経由してください。
    *   **Exception**: 認証 (`auth`), Realtime購読, Fire-and-forgetなRPC（閲覧数カウント等）のみ例外として許可されます。

### 13.1.y. The Centralized Logging Protocol (Zero Console)
*   **Law**: 本番環境における `console.log` や `console.error` の放置は「衛生管理欠如」です。構造化されていないログは検索不能であり、ノイズです。
*   **Action**:
    *   **Logger Only**: APIやAction内では、必ず `src/lib/logger.ts` (Logger) を使用してください。
    *   **Prohibition**: `console.*` メソッドの使用を禁止します（Linterでブロック推奨）。

### 13.1.w. The Pragmatic Casting Protocol (Type Survival)
*   **Context**: 自動生成された型定義（`Database`）にまだ存在しないテーブル（Phantom Tables）へのアクセスが必要な場合、CIを通すために一時的なバイパスが必要です。
*   **Law**: `as any` は禁止ですが、意図的なブリッジキャストは許容します。
*   **Action**:
    *   **Local Extension**: 不足している型定義を `src/types/database-extensions.ts` に局所定義してください。
    *   **Bridge Pattern**: `(supabase as any).from('table')` を許容し、戻り値を直後に `data as MyLocalRow[]` とアサーションすることで、実用的な型安全性を確保してください。ただし、これは正規の型定義が生成されるまでの**一時的な処置**としてください。

### 13.1.z. The Unstable Timer Protocol (SetTimeout Ban)
*   **Law**: `setTimeout` や `setInterval` は実行タイミングが保証されず、サーバーレス環境（Edge）や高負荷時にシステムを不安定にします。
*   **Action**: ロジック制御のためにタイマーを使用することを禁止します。必要な場合はイベント駆動アーキテクチャ、ジョブキュー（Background Jobs）、または `requestAnimationFrame` を使用してください。

### 13.1.x. The Type Bridge Mandate (No Implicit Any)
*   **Law**: 自動生成型（`database.types.ts`）に不足がある場合でも、`as any` で逃げることは許されません。「ビルドが通る」と「型が安全」は別物です。
*   **Action**:
    *   **Extension**: `src/types/database-extensions.ts` に拡張型 (`DatabaseExtended`) を定義し、不足しているViewやRPCを補完してください。
    *   **Bridge**: Supabaseクライアント初期化時にこの拡張型をジェネリクスとして渡し、アプリ全体で型安全性を維持してください。
    *   **Mapped Type**: 拡張型を定義する際は、交差型（`&`）ではなく **Mapped Type (写像型)** を使用し、型衝突による `never` や `undefined` への退化を防いでください。

### 13.2. The API Product Mindset (Data Monetization Protocol)
*   **Law**: 全てのデータ出力は「商品（Product）」です。「Internal APIだから」という甘えは、セキュリティと収益化の機会を損ないます。
*   **Action**:
    *   **Strict Tiering**: APIは必ず **Tier 1 (Public/Free)** と **Tier 2 (Enterprise/Paid)** に分離できる設計にしてください。
    *   **Usage Recording**: 全ての Enterprise API エンドポイントにおいて、成功時に `recordApiUsage` を **Fire-and-forget** パターンで呼び出し、使用量を監査ログに残してください。
    *   **Metadata**: レスポンスには `meta` フィールド（AI用メタデータ、Tier情報、生存期間TTL）を含め、AIエージェントの自律判断を支援してください。
    *   **Standard Metadata**: Tier 1/2 の API においては、メタデータ内に `tier` (public, enterprise), `usage` (metered, unlimited), `revalidation` (ttl) 等の情報を付与し、FinOps最適化を支援してください。

### 13.2.x. The Tenant-Aware Naming Protocol
*   **Law**: 将来的なSaaS化（マルチテナント）を見据え、リソース名は明確に区別します。
*   **Action**:
    *   **Site/Tenant**: 顧客（テナント）ごとの設定やリソースには `site_` や `account_` を接頭辞として使用します（例: `site_settings`）。
    *   **System**: 全テナント共通の不変な基盤設定にのみ `system_` を使用します。これにより `tenant_id` 追加時の設計破綻を防ぎます。

### 13.2.y. The Legal Hardcoding Ban (DB SSOT)
*   **Law**: 利用規約、プライバシーポリシー、特定商取引法に基づく表記などの法的テキストをソースコードに直書き（Hardcoding）することは禁止です。
*   **Action**:
    *   **DB First**: これらは必ず `site_settings` テーブルのカラムとして定義し、管理画面から非エンジニアが即座に修正可能な状態にしてください。
    *   **Risk**: 法改正時にエンジニアのデプロイを待つタイムラグは、コンプライアンス違反のリスクとなります。

### 13.3. The Native Session Bypass Protocol (VIP Lane Strategy)
*   **Law**: 自社開発のネイティブアプリ（First Party App）にAPI Key等の秘密鍵を埋め込むことは、セキュリティリスクです。
*   **Action**:
    *   **Common Endpoint**: APIエンドポイントをPublicとFirst Partyで安易に分離（BFF乱立）せず、共有してください。
    *   **Dual Auth (VIP Lane)**: Middlewareにおいて「API Key認証」と「Bearer Token認証 (User Session)」のOR条件を実装し、キーを持たない自社アプリ（ログインユーザー）には無条件で特権（Tier 2相当）を付与する「VIPレーン」を確立してください。これによりアプリ内への秘密鍵埋め込みリスクを排除します。
