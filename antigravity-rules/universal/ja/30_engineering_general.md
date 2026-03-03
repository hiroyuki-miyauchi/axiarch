# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

## 1. コード品質とクリーンコード (Code Quality & Clean Code)

### 1.0. 至高の指令 (The Supreme Directive)
*   **The Consolidated Naming Convention**:
    *   **Files & Directories**: 全てのファイル名とディレクトリ名は `kebab-case` (例: `user-profile-card.tsx`) で統一します。PascalCaseやsnake_caseはOS間のGit互換性問題（Case Sensitivity）を引き起こすため厳禁です。
    *   **Components**: ファイル名は `kebab-case` ですが、コンポーネント名は `PascalCase`、関数名は `camelCase` とします。
    *   **The Barrel File Ban**: `index.ts` による再エクスポート（Barrel File）は、循環参照とTree Shaking阻害の主因となるため、原則禁止とします。
- **UI/Logic Consistency (完全統一)**:
  - **原則**: 「似ているが違う」はプロ意識の欠如であり、バグです。すべての機能（削除、編集、一覧）において、UIとロジックは統合されていなければなりません。
  - **Tiered Security**: セキュリティはリスクに応じて段階化します。
    - **Tier 1**: 一般的な単体操作は「確認のみ」とします。
    - **Tier 2**: 一括操作、および**ユーザー削除などの最重要単体操作**は「高セキュリティ認証（OTP/Passkey/2FA等）必須」とします。これを独自の判断で崩すことは許されません。
*   **The Hierarchical Data Principle (1:N Core)**:
    *   **Law**: 複雑なドメイン（ライフタイムデータ、契約、高秘匿記録等）を設計する際は、必ずルートとなる親テーブル（例: `users`, `accounts`, `master_records`）を定義し、関連データは $1:N$ の階層構造でぶら下げる「疎結合な親子関係」を貫いてください。単一の巨大なテーブルへの押し込み（God Table）は、マイグレーションとRLS設計の破綻を招く敗北行為です。
*   **The Tiered Service Mandate (Subscription Gating)**:
    *   **Law**: サービスレベル（Free/Paid）による制限（登録数、AI利用回数等）は、必ず **サーバーサイド (Server Guards)** で強制してください。フロントエンドの表示制御のみに頼ることは、APIリクエストによる回避を許すため禁止します。
    *   **Upsell Trigger**: 制限超過時には、単なる「エラー」ではなく、上位プランへの動線を伴う明確なメッセージを返却してください。
*   **The Interoperable Ecosystem Mandate**:
    *   **Law**: アプリ内に保持される重要なドメインデータ（実績、資格、記録等）を、システムの外でも通用する「標準化された資産」として扱ってください。独自仕様に閉じ込めることは、将来のサービス連携とユーザーへの価値提供を阻害する敗北行為です。
    *   **Portable Design**: 可能な限り業界標準のスキーマ、定数、国際規格に準拠し、データそれ自体が「信頼性の高い証明書」として他システムへのポータビリティ（携行性）を持つように設計してください。
*   **Structure First Protocol**:
    *   **Law**: 重要なビジネスデータ（資格、契約、健康状態、資産等）は、テキスト（非構造化データ）ではなく、可能な限りマスターデータ（M:N）やタグ形式で構造化して管理してください。
    *   **Future-Proof Data Strategy (LTV & FinOps)**: 
        *   **Context**: 特定のデータ（例: 医療費、故障率、ライフタイムイベント）は、現時点で不要であっても、将来の保険提案や高度なパーソナライズ、ビジネスモデルの転換において「黄金のデータ」となります。
        *   **Law**: データモデリング時は、将来的な FinOps や LTV 最大化に寄与する可能性のあるメタデータ（コスト、発生日時、種別、事象）を、構造化された形で保持できるように設計してください。「後で追加する」コストを最小化し、データの連続性を担保します。
    *   **Autonomous Structure Strategy (Edge AI)**: 
        *   **Law**: ユーザーに入力（Typing）という苦役を強いることは可能な限り避け、紙の証明書、領収書、書類等の「非構造化物理アセット」は、OCR/Vision AI を活用して即座に「高精度な構造化データ」へ自動変換するフローを標準実装として検討してください。
        *   **Standard**: 「写真を撮るだけで、重要な全項目が DB に入る」UX を、データ品質維持とユーザー継続率向上のための至上命題とします。
        *   **Human-in-the-Loop Mandate**: AI（OCR/Vision等）によるデータ抽出・変換結果は、常に **「下書き（Draft）」** として扱い、**ユーザーが目視で確認・修正した上で「保存」ボタンを押す**フローを強制してください。AIによるDBへの直接書き込み（Auto-Save）は、誤データの混入リスクがあるため禁止します。
        *   **PII Scrubbing**: AI処理対象の文書や画像に個人情報（氏名、住所、電話番号等）が含まれる場合、OCR/AI結果としてそのまま保存せず、自動的に破棄またはマスキング（`***`等で置換）してください。特に第三者の個人情報は、本人の同意なく構造化データとして保持してはなりません。
*   **Blueprint Compliance (憲法遵守)**:
    *   **Entry Point**: すべての開発作業は、まず対応するルールファイルを確認することから始めます。
    *   **Update First**: 実装中に設計変更が必要になった場合、**コードを書く前に（または同時に）Blueprintを更新**します。ドキュメントとコードの乖離は最大の技術的負債です。
    *   **Code as Documentation**: Blueprintファイルはコードの一部です。実装を変更したら、必ず対応するルールファイルも更新し、乖離（Drift）を防いでください。
*   **警告ゼロ (Zero Warnings)**:
    *   **ルール**: 警告（Warning）はエラー（Error）として扱います。CIは警告が1つでもあれば失敗させます。「壊れた窓割れ理論」を防ぎます。
    *   **厳格なエラーハンドリング**: 空の `catch` ブロックは禁止です。全てのエラーはログに記録され、適切に処理されなければなりません。
    *   **Zero Tolerance for Band-Aid Solutions**:
        *   **Prohibition**: `// @ts-ignore`, `any` キャスト、`legacy-peer-deps` は「思考停止」であり、エンジニアとしての敗北です。
        *   **Mandate**: 一時的な回避が必要な場合は、必ず `// TODO(#IssueID): reason` とチケット番号を添えて理由を記述してください。無言の `ignore` は即時Reject対象です。
    *   **The Incident Response Protocol (SRE)**: 
        1. **Plan & Drill**: セキュリティインシデント（情報漏洩、不正アクセス）発生時の連絡網と初動対応（サービス停止基準、ログ保全）を定義し、半年に1回訓練を行ってください。
        2. **Post-Mortem & Blueprint Sync**: 障害・インシデント対応後は必ず根本原因を特定して言語化し、その教訓を即座に **Blueprint (設計書)** へ反映させるまでを一つの不可分なプロセスとします。
    *   **The Anti-Blindness Protocol (AI Hygiene)**:
        *   **Law**: AIが生成したコードに含まれる `// ...` や `// implementation details` といった省略記法を、そのままファイルに保存することを物理的に禁止します。
        *   **Action**: 必ず**完全なコード**を展開させてください。省略されたコードは「バグ」ではなく「虚無」であり、システムをクラッシュさせます。
    *   **The System Transparency Protocol (Stack Card)**:
        *   **Law**: 使用している技術スタック（Framework, DB, UI Lib）のバージョン情報を、`PROMPT.md` または `tech_stack.md` に常に最新状態で維持してください。
        *   **Reason**: AIエージェントは「現在」の環境を知る由もありません。正確なバージョン情報こそが、正確なコード生成の命綱です。
*   **リファクタリング (Refactoring - The Boy Scout Rule)**:
    *   **義務 (Mandate)**: 「来た時よりも美しくして立ち去る（ボーイスカウトの精神）」。ファイルを触る際は、必ず小さな改善（命名変更、関数抽出）を行います。
    *   **「後で」はない (No "Later")**: 「後でリファクタリングする」は嘘です。今やるか、永遠にやらないかです。
    *   **複雑度の排除 (Cyclomatic Complexity)**: 複雑度（ネストの深さ）が高いコードは、バグの温床です。早期リターン（Early Return）を活用し、ネストを浅く保ちます。
*   **クリーンアップ (Cleanup)**:
    *   **デッドコードの即時削除**: コメントアウトされたコード、使われていないインポート、デバッグ用の `console.log` は、コミット前に完全に削除します。
    *   **TODOコメントの管理**: `// TODO:` を残す場合は、必ずチケット番号または期限を併記します。放置されたTODOは技術的負債です。
*   **根本原因優先 (The Root Cause First Protocol)**:
    *   **Prohibition**: エラー発生時、原因を特定せずに「とりあえず動く修正（Band-Aid Fix）」を適用することを禁止します。
    *   **Process**:
        1.  **Reproduce（再現）**: エラーをローカルで確実に再現させてください。
        2.  **Diagnose（診断）**: ログ、スタックトレース、依存関係ツリー等を分析し、「なぜ起きたか」を言語化してください。
        3.  **Fix Root（根本修正）**: その場しのぎの緩和策（SSL検証無効化、型キャスト、`--legacy-peer-deps`）ではなく、根本原因（証明書更新、型定義修正、`overrides` 設定）を解決してください。
    *   **Rationale**: バンドエイド修正は「時限爆弾」です。短期的には動作しますが、環境変更やライブラリ更新時に予測不能な障害を引き起こします。
*   **設定変更影響分析 (The Config Change Impact Analysis Protocol)**:
    *   **Context**: ビルド設定（`next.config.ts`等）、コンパイラ設定（`tsconfig.json`等）、スタイル設定（`tailwind.config.ts`等）のプロジェクト全体設定ファイルの変更は、コードベース全体に予期しない影響を波及させます。
    *   **Mandate**:
        1.  **Impact Scan**: 設定変更前に、影響を受ける可能性のある全ファイルを `grep` で特定してください。
        2.  **Approval Gate**: 影響ファイル数が10を超える場合、変更適用前にレビュワーまたは責任者の承認を得てください。
        3.  **Atomic Fix**: 影響のある全ファイルを同一コミット（またはPR）で修正し、半端な状態を防止してください。
    *   **Scan Examples**:
        *   `trailingSlash` 変更 → 全 `router.push` / `redirect` / `Link href` をスキャン
        *   `paths` エイリアス変更 → 全 `import` 文をスキャン
        *   `images.remotePatterns` 変更 → 全 `<Image>` コンポーネントをスキャン
*   **The Silent Async Bug Pattern（await欠落バグパターン）**:
    *   **Law**: データベース書き込み操作（`.insert()` / `.update()` / `.delete()` / `.upsert()`）や外部API呼び出しなどのPromiseを返す非同期関数には、**必ず `await` を付与してください**。`await` の欠落は、書き込みが「サイレントに失敗」し、エラーも発生せずデータが消失する最も診断困難なバグの原因です。
    *   **Action**:
        1.  `async` 関数内のPromiseを返す操作に `await` がない場合は即座に修正してください。
        2.  ESLint `@typescript-eslint/no-floating-promises` ルールの有効化を推奨します。
        3.  監査時は、DB操作の `await` 欠落を `grep` で検出してください。
    *   **Anti-Pattern**: `supabase.from('messages').insert({ content: text })` （❌ awaitなし — Promiseが浮遊しサイレント失敗）
*   **The Codebase-as-Truth Protocol（コードベースを正とする原則）**:
    *   **Law**: フレームワークやライブラリのAPIを使用する際、「公式ドキュメント」よりも「既存コードベースの実装パターン」を正としてください。ドキュメントは古い場合がありますが、動いているコードは常に最新です。
    *   **Action**:
        1.  APIや関数を使用する前に、必ず `grep` で既存の使用例を検索し、プロジェクト内で確立されたパターンに従ってください。
        2.  公式ドキュメントと既存コードの実装が矛盾する場合、既存コードの実装を優先してください。
        3.  新しいパターンを導入する場合は、既存のコードベースとの一貫性を確認し、不整合があれば先に既存コードを統一してください。
    *   **Rationale**: 公式ドキュメントはバージョンアップや廃止の反映が遅れることがあります。「ドキュメント通りに書いたのに動かない」という時間浪費を防ぎます。

### 1.1. Supreme Directive: Omnichannel & Headless First Protocol
*   **Web is just ONE Client**:
    *   **Definition**: システム全体を設計する際、「Webサイト（Next.js）」は多数あるクライアントの**ほんの一つ**に過ぎないと定義します。
    *   **Vision**: 将来的なネイティブアプリ（iOS/Android）、外部メディア連携、IoT配信、AIエージェントとの対話を前提とします。
*   **API Mandate**:
    *   **Law**: **全ての機能とデータ** は、再利用可能な API (Headless Architecture) を介して提供されなければなりません。
*   **Prohibition (The Web-Only Ban)**:
    *   **Felony**: Reactコンポーネント内へのビジネスロジックの閉塞や、HTML構造に依存したデータ設計（Web Only設計）は、**「再最重要項目の違反」として厳禁** とします。これを行った場合、即時のReject対象となります。

### 1.2. Supreme Directive: Realism First Protocol (Anti-Haribote)
*   **Definition**:
    *   **Haribote (ハリボテ)**: UI（皮膚）が存在しても、その背後で「データの永続化」と「再取得（Hydration）」が完全に行われていない機能は、いかなる理由があっても**「詐欺的実装（Deception）」** と定義し、実装完了とは認めません。
*   **Mandate (The Vein Check)**:
    *   **Rule**: 機能実装の完了条件は、UIの描画ではなく、**「UI → Action → DB → Action → UI」** というデータの血管（Round-Trip）が疎通していることを確認するまでコミットしてはなりません。
    *   **Physical Verification**: 開発者ツールだけでなく、必ずDB（psql/Table Editor）で**物理的に値が書き込まれていること**を確認する義務を負います。「動いているように見える」は禁止です。
*   **Deception Penalty**:
    *   保存されない設定画面や、リロードすると消える入力フォームをPRに含めることは、レビュワーとユーザーに対する**裏切り行為（Betrayal）**であり、修正完了まで全ての作業を凍結します。

## 2. インフラとパフォーマンス (Infrastructure & Performance)
*   **インフラストラクチャ基準 (The Golden Quad)**:
    *   **Managed Hosting**: Vercel Pro等、DDoS保護とスケーラビリティを備えたマネージドホスティングを利用します。
    *   **BaaS**: Supabase等、DBとバックアップ機能が統合されたBaaSを「唯一の正解」として利用します。
    *   **Edge Shield**: Cloudflare等のエッジWAF/CDNを配置し、攻撃と負荷をエッジで吸収します。
    *   **Email Deliverability**: Resend等、開発者体験と到達率に優れたメールインフラを採用します。
    *   **The Email Deliverability Protocol (DMARC/RFC 8058)**:
        *   **Authentication**: `DMARC`, `SPF`, `DKIM` レコードの設定を完全に義務付けます。これらが未設定のドメインからの送信は、Gmail/Yahoo等の主要プロバイダによりブロックされるため、**「機能不全」と同義**とみなします。
        *   **One-Click Unsubscribe**: マーケティングメールには、必ず `List-Unsubscribe` ヘッダー (RFC 8058) を付与し、メールアプリのネイティブUIから1クリックで解約できる導線を実装してください。これを行わない場合、スパム判定リスクが極大化し、ドメイン全体の信頼性（Reputation）を毀損します。
*   **読み取り最適化 (Read-Optimized Architecture)**:
    *   **事前計算 (Pre-calculation)**: ランキング、集計、複雑なフィルタリング結果は、リクエストごと（On-the-fly）に計算せず、データ更新時または定期バッチで事前計算し、DBのカラム（例: `ranking_score`, `total_sales`）に保存します。
    *   **CQRS**: 参照系と更新系のモデルを分離し、参照系には非正規化（Denormalization）された読み取り専用テーブルやマテリアライズドビューの使用を推奨します。
    *   **The Hybrid CMS Design Strategy (Layout vs Content)**:
        *   **Context**: 並び替え順序や表示設定を正規化（RDB）すると、UI実装が複雑化しN+1を招きます。
        *   **Action**: 「レイアウト・順序」はJSON (`site_settings.sidebar_order`) で管理し、「コンテンツ」はRDBテーブル (`posts`) で管理するハイブリッド構成を標準とします。JSONの柔軟性とSQLの検索性を両立させます。
*   **パフォーマンス予算 (Performance Budgets)**:
    *   **Lighthouseスコア**: Performance, Accessibility, Best Practices, SEO の全てで **90点以上** を維持します（緑色）。
    *   **Core Web Vitals**: LCP (2.5s以内), **INP (200ms以内)**, CLS (0.1以内) を厳守します。
*   **アセット最適化 (Asset Optimization)**:
    *   **画像 (Images)**: 次世代フォーマット（AVIF/WebP）を強制します。`next/image` 等の最適化コンポーネントを使用します。
    *   **遅延読み込み (Lazy Loading)**: ファーストビュー（Above the fold）以外の全てのアセットは遅延読み込みします。
    *   **The Fixed Page Protocol (Dynamic Static Pages / SEO & Legal)**:
        *   **Law**: 利用規約、プライバシーポリシー、特定商取引法等の「静的だが更新可能なページ」を、物理的な `page.tsx` として個別に作成することを厳禁とします。
        *   **Action**: `src/app/(public)/[slug]/page.tsx` 等の動的ルートを使用し、DBの `fixed_pages` テーブル（または `site_settings`）からコンテンツを取得するアーキテクチャを採用してください。これにより、法改正時のコード変更・再デプロイのタイムラグをゼロにし、コンプライアンスを物理的に保証します。
*   **API-Free First Protocol (無料代替優先原則)**:
    *   **Law**: 有料の外部API（Geocoding、住所補完、画像最適化等）を採用する前に、以下の無料代替手段を必ず検討する義務を負います。安易な有料API導入はFinOpsの敗北です。
    *   **Free Alternatives Checklist**:
        1.  **既存データからの抽出**: URL解析、メタデータ解析等で必要な情報を取得できないか検討する。
        2.  **クライアントサイドAPI**: Browser Geolocation API、Web Crypto API等のブラウザ標準APIを活用する。
        3.  **オープンデータの活用**: 郵便番号→住所DB、公開統計データ等を利用する。
        4.  **1回取得→DB保存パターン**: 座標、住所補完結果、通貨レートなど頻繁に変わらないデータは、初回のみ取得してDB保存し再利用する。
    *   **Documentation**: 有料APIを採用する場合は、「なぜ無料代替が不可能か」の理由を実装計画書に明記してください。

## 3. 設計によるセキュリティ (Security by Design - DevSecOps)
*   **ゼロトラスト (Zero Trust)**:
    *   全ての入力（ユーザー入力、APIレスポンス）を疑います。バリデーションはクライアントとサーバーの両方で行います。
*   **機密情報管理 (Secrets Management)**:
    *   APIキーや秘密鍵はコードにコミットしません。`.env` ファイルとシークレットマネージャーを使用します。
    *   **The Single Source of Config**:
        *   **Prohibition**: コードの各所（コンポーネント内等）で直接 `process.env.NEXT_PUBLIC_...` を参照することは、変更時の修正漏れや型安全性の欠如を招くため禁止です。
        *   **Action**: 必ず `src/lib/config` (または `env.ts`) で一元管理し、アプリケーション全体からはその定数オブジェクトのみを参照してください。この層で存在チェック（Validation）を行うことを推奨します。
    *   **The Environment Template Sync Protocol（環境変数テンプレート同期義務）**:
        *   **Law**: プロジェクトルートに `.env.example`（または `.env.template`）を常設し、必要な全環境変数の**キーのみ**を記録する義務を負います（値は空文字またはプレースホルダ）。
        *   **Sync Mandate**: 新しい環境変数を追加した場合、**同一PRで** `.env.example` も更新しなければなりません。未更新は「新規開発者のオンボーディング障害」とみなします。
        *   **Git Safety**: `.env.local` / `.env.production` 等の実値を含むファイルは `.gitignore` に含め、**絶対にコミットしてはなりません**。
        *   **Rationale**: `.env.example` が存在しない、または古い状態のプロジェクトは、新規メンバーが環境構築に何時間も費やし、既存メンバーに都度質問する「属人化の温床」です。
    *   **The Environment Variable Drift Prevention Protocol（環境変数ドリフト防止義務）**:
        *   **Law**: 環境変数の欠落や環境間の不整合（Drift）は、「ローカルでは動くがCI/本番で壊れる」最大の原因です。環境変数の完全性を自動的に検証する仕組みを構築してください。
        *   **Action**:
            1.  **Startup Validation**: アプリケーション起動時に、必須環境変数の存在チェック（バリデーション）を実行し、不足している場合は**起動を中断**してください。「`undefined` のまま動作して途中でクラッシュする」状態を物理的に防止します。
            2.  **CI Parity Check**: CIパイプラインにおいて、`.env.example` に記載された全キーがCI環境のシークレット/変数として定義されていることを検証するステップを追加してください。
            3.  **Type-Safe Config**: 環境変数は文字列として取得するだけでなく、Zodやio-ts等で**型レベルでバリデーション**し、不正な値（空文字列、不正なURL形式等）を起動時に検出してください。
        *   **Rationale**: 環境変数の欠落は、コードレベルのバグではなくインフラ設定のバグであり、型チェックやLintでは検出できません。起動時バリデーションは、このカテゴリのバグを「デプロイ直後」に検出する唯一の確実な手段です。

## 4. 技術的負債とクリーンアップ (Technical Debt & Cleanup)
*   **負債の返済 (Debt Paydown)**:
    *   スプリントの **20%** は技術的負債の返済（リファクタリング、ライブラリ更新）に充てます。
    *   **The TODO/FIXME Protocol (Ticket First)**:
        *   **Law**: コード内の `// TODO:` や `// FIXME:` は、チケット（Issue）化されなければ「単なる落書き」です。
        *   **Action**: TODOコメントを残す際は、必ず対応する Issue 番号を併記（例: `// TODO(#123): Refactor later`）することを義務付けます。番号のないTODOはPRで却下されます。
*   **テックレーダー (Tech Radar)**:
    *   **定期更新**: 依存ライブラリは四半期ごとに更新し、常に「安全な最先端（Bleeding Edge）」を維持します。
    *   **Dependency Watch (24-Hour Mandate)**: `npm audit` を定期的に実行してください。**High/Critical** な脆弱性が発見された場合は、発見から **24時間以内** にパッチ（`npm audit fix`）を適用するか、緊急の回避策を講じることを義務付けます。
*   **デジタル5S (Digital 5S)**:
    *   **整理 (Seiri)**: 未使用のコード（Dead Code）、画像、ファイルは即座に削除します。コメントアウトされたコードを残しません。
    *   **The Dependency Governance Protocol**:
        *   **Dual Governance**: ネイティブ依存を含むパッケージ（`tree-sitter` 等）で環境差異エラーが出る場合は、`package.json` の `overrides` フィールドを使用してバージョンを強制統一します。
        *   **The License Quarantine (AGPL Block)**: ライセンスガバナンスの詳細については、`60_security_privacy.md` の Rule 5 を参照し、**AGPL (Affero GPL)** の使用防止を徹底してください。
        *   **The Lockfile Integrity Protocol（ロックファイル整合性保証）**:
            *   **Law**: ロックファイル（`package-lock.json` / `yarn.lock`）の不整合によるCI失敗や「ゴーストエラー」を「大罪」として禁じます。
            *   **CI Discipline**: CIパイプライン上では必ず `npm ci`（または相当コマンド）を使用し、ロックファイルを厳密に守らせてください。`npm install` をCIで使用することは、ロックファイルを無視する行為であり禁止です。
            *   **Silver Bullet**: ローカルとCIで挙動が異なる場合、調査に時間を費やす前に `rm -rf node_modules package-lock.json && npm install` を実行し、ロックファイルを完全に再生成してください。
            *   **Prohibition**: 依存関係変更後にロックファイルをコミットせずにPushすることを禁止します。
    *   **The Console Log Ban (Information Leakage)**:
        *   **Law**: 本番ビルドにおいて `console.log` を残すことは、デバッグ情報の垂れ流しであり、機密情報（トークンやPII）漏洩の温床です。
        *   **Action**: `eslint-plugin-no-console` を `error` に設定し、CIで物理的にブロックしてください。必要なログは `logger` ライブラリ経由でSentry等に送信します。
    *   **The Privacy Scrubbing Protocol (EXIF Wipe)**:
        *   **Context**: ユーザー投稿画像（UGC）には、撮影場所（GPS座標）などの個人情報が含まれている場合があります。
        *   **Law**: クライアントサイドでの画像アップロード処理において、**EXIF情報の物理削除**を義務付けます。サーバーに到達する前に、ブラウザ上でメタデータを浄化してください。
    *   **The Backup File Ban (No .bak)**:
        *   **Law**: 「念のため取っておく」バックアップファイル（`.bak`, `.old`, `_copy`）は、Git管理下においてはノイズであり、検索結果を汚染し、最新コードとの混同を招きます。
        *   **Action**: バックアップはGitの履歴です。ファイルシステム上のバックアップファイルは即時削除してください。`ls` した時に本番で使用されるファイル以外が存在してはなりません。
    *   **The Exhaustive Reference Scan (Grep First)**:
        *   **Law**: 「自分の記憶」に基づいたファイル削除は、未検知のインポートエラーやビルド破壊を招く「博打」です。
        *   **Action**: ファイルを削除・リネームする際は、必ずプロジェクト全体を対象にファイル名で **`grep` 検索** を行い、全ての参照箇所を特定・排除してから実行してください。
    *   **The Dead Export Detection Protocol（デッドエクスポート検出義務）**:
        *   **Law**: エクスポートされた関数・型・定数の使用箇所がゼロになった場合、即座に除去しなければなりません。「Dead Code」だけでなく「Dead Export」も負債です。
        *   **Action**:
            1.  監査時は `grep -r "functionName" src/` で全エクスポートの使用箇所を確認してください。
            2.  使用箇所ゼロのエクスポートは即座に除去し、関連する型定義も連鎖クリーンアップしてください。
            3.  型エイリアス（`type X = Y`）が唯一の使用箇所ならば、エイリアスごと除去を検討してください。
        *   **Rationale**: Dead Exportは「誰かが使っているかもしれない」という心理的ブロックにより放置されやすいですが、未使用のエクスポートは依存グラフを複雑化し、Tree Shakingの効果を阻害し、リファクタリング時の認知負荷を増加させます。
    *   **The Ghost Feature Ban**: ユーザー導線が存在しない機能（公開されていない管理画面コード等）は負債です。YAGNI原則に従い、物理削除してください。
    *   **The Ghost Feature Revival (Full-Stack Coherence)**:
        *   **Law**: 管理画面で設定を変更しても、フロントエンドで何も変化しない機能（Ghost Feature）は、システムへの信頼を破壊するバグです。
        *   **Action**: 管理画面の設定項目を追加する際は、必ずフロントエンドでの反映ロジック（CSS変数の注入、API項目の表示等）を同時に実装し、結合テストを行ってください。設計の半分（片方）だけの実装は「未完成」とみなします。

## 5. AIファースト開発 (AI-First Engineering)
*   **Prompt Driven Development (PDD)**:
    *   **原則**: コードは人間が書くものではなく、AIに書かせるものです。「プロンプト」こそが真のソースコードです。
    *   **AIフレンドリー**: 変数名や関数名は、AIが文脈を理解しやすいように、極めて記述的（Descriptive）にします（例: `x` ではなく `daysSinceLastLogin`）。
*   **RAG最適化 (RAG Optimization)**:
    *   **モジュール化**: ファイルサイズは小さく保ち（Atomic）、AIのコンテキストウィンドウを圧迫しないようにします。
    *   **Explicit Imports**: `import` ステートメントは必ずファイルの最上部（Top-Level）に記述してください。関数内や条件分岐内でのインポートは、静的解析を妨げ、AIの理解を困難にします。
    *   **セマンティック構造**: ディレクトリ構造は機能単位（Feature-based）で整理し、AIが関連ファイルを見つけやすくします。
*   **Schema Trust Protocol (No Ghost Columns)**:
    *   **Law**: 設計書（Blueprint）に予定されているが、DBマイグレーションがまだ適用されていないカラム名をクエリ（SELECT/INSERT/UPDATE）で使用することを禁止します。存在しない列へのアクセスはページ全体をクラッシュさせます。
    *   **Action**: クエリで使用するカラムは「現在、確実に存在する」ものに限定し、未実装機能のデータはアプリケーション層の定数（Default Config）で補完してください。

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
*   **The Framework Signature Reality (Codebase as Truth)**:
    *   **Context**: ライブラリやフレームワークの公式ドキュメントは更新が遅れることがあります。
    *   **Law**: 公式ドキュメントよりも「既存コードベースのシグネチャ（実際の型定義）」を正とします。APIを使用する前に、必ず `grep` やIDEの定義ジャンプで既存使用例と型定義を確認してください。「ドキュメント通りに書いたのに動かない」は言い訳になりません。
*   **The Fix Twice Principle (再発防止)**:
    *   バグを修正する際は、「そのバグを直す (Fix Once)」だけでなく、「二度と同じバグが起きない仕組み（Lint追加、型厳格化、テスト追加）を作る (Fix Twice)」までをワンセットとします。

## 8. 継続的学習と検証 (Continuous Learning & Verification)
*   **最新情報の確認義務 (Latest Info Protocol)**:
    *   **開発着手前**: コードを書く前に、必ず対象技術の公式ドキュメントや最新のリリースノート（例: "Next.js 15 breaking changes", "Swift 6 concurrency"）を確認します。古い情報に基づいた実装は手戻りの元です。
    *   **非推奨チェック**: 使用しようとしているAPIが Deprecated（非推奨）になっていないか確認します。
*   **トレンドの把握**:
    *   シリコンバレーの最新トレンド（AIエージェント、Privacy Manifests等）を常にキャッチアップし、ルール自体も進化させ続けます。
*   **The Crystallization Protocol (Knowledge Extraction)**:
    *   **Law**: 機能実装完了後、その過程で得られた「暗黙知」「新しいパターン」「ハマったポイント」は、設計書（Blueprint）やルールファイルに文書として還元する義務を負います。
    *   **Rationale**: 知識がコードにのみ存在する状態は「経験の揮発」です。次の開発者（人間・AI問わず）が同じ轍を踏むことを防ぐため、得られた学びを即座にドキュメント化する習慣がチームの生産性を指数関数的に向上させます。

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
    *   **Branch Naming Standard**:
        *   ブランチ名は `type/summary` 形式で統一します（例: `feat/user-profile`, `fix/login-bug`）。
        *   Types: `feat` (機能), `fix` (修正), `refactor` (改善), `chore` (雑用)。
*   **コミットメッセージ (Conventional Commits)**:
    *   `type(scope): subject` 形式を厳守します（例: `feat(auth): add google login`）。本文には日本語で詳細を記述します。
    *   **Atomic Commits**: 1つのコミットには「1つの論理的変更」のみを含め、バグ発生時に「そのコミットだけ」をRevertすれば直る粒度を保ちます。
*   **プルリクエスト (Pull Requests)**:
    *   **The Pull Request Template Protocol**:
        *   **Law**: `.github/pull_request_template.md` を作成し、レビュワーに「何を、なぜ、どうやって検証するか」を強制的に入力させます。
        *   **Content**: "Type of change", "How to test", "Screenshots" の3項目は必須です。
    *   **The CI Timeout Protocol**:
        *   **Law**: すべてのCIジョブには必ず `timeout-minutes: 10` を設定してください。リソースの浪費と無限ループを防ぐため、10分を超えるビルドは「設計ミス」とみなします。
    *   **100行ルール**: PRは小さく保ちます。
    *   **保護設定**: `main` への直接プッシュは禁止し、CI（Build, Test, Lint）通過とレビュー承認を必須とします。
    *   **Husky Guard (Universal Mandate - Deep Defense)**:
        *   **Law**: 全てのプロジェクトにおいて、**Husky** の導入および `pre-push` フックによる `main` (および `master`) ブランチへの直接プッシュ禁止設定を **義務（Universal Mandate）** とします。サーバーサイドの保護設定が可能な場合でも、防衛線を物理的に二重化（Deep Defense）し、「間違ってプッシュした」という言い訳を物理的に不可能にしてください。
        *   **Law 2 (No Human Trust)**: 「気をつける」という運用ルールは無意味です。物理的にプッシュできない仕組み（Code not Policy）のみを信頼してください。
        *   **Action**: プロジェクト初期化時に必ず `npx husky init` を実行し、ガードレールを設置することを初期化フェーズの必須要件とします。
    *   **The Automated Git Hooks Protocol (Lint Staged)**:
        *   **Law**: 人間の「気をつける」を排除します。`lint-staged` を導入し、コミットされるファイルに対して自動的に `eslint --fix` と `prettier --write` を実行することを義務付けます。
        *   **Outcome**: これにより、「汚いコード」がGit履歴に混入することを物理的に阻止します。
    *   **The Red Button Checklist (Deploy Final Gate)**:
        *   **Law**: 本番デプロイ直前には、以下の項目を**指差し確認**することを義務付けます。
            1. **Legal**: 利用規約・プライバシーポリシーは最新か？
            2. **Security**: RLSポリシーは `Anon` でテスト済みか？
            3. **FinOps**: クラウドの予算上限（Spend Cap）は有効か？
            4. **Data**: 本番用マスターデータは投入済みか？
    *   **Branch Hygiene Mandate (ゴミ屋敷撲滅・最重要規定)**:
        *   **Law**: マージ済みのローカルブランチを放置することは、環境差異による事故と混乱を招く「エンジニアとして恥ずべき行為」であり、開発環境を「ゴミ屋敷」化させる諸悪の根源です。
        *   **Action**: 作業ブランチを閉じる際は、必ず「ローカルとリモートの差異確認」と「不要ブランチの削除（掃除）」を完了条件とします。タスク完了の報告（Final Notify）の直前に、必ず `git branch --merged` を確認し、不要になった作業ブランチを物理削除することを**エンジニアの呼吸**としてください。
    *   **Omnichannel Check**: レビュー時は「Web以外（iOS/Androidアプリ）でも利用可能か？」を最優先で確認します。"Web Only" のロジックは即座にRejectします。
    *   **Deployment Safety Protocol**:
    *   **Supreme Directive: The AI Git Ban (Refer to 00)**:
        *   **Ref**: AIによるGit操作の絶対禁止については、最高法規 `00_core_mindset.md` の Rule 8.1 を参照し、これを厳守してください。
    *   **The Automated Deployment Mandate (CD First)**:
        *   **No Manual Deployment**: 本番環境へのデプロイ（DB変更含む）を、開発者の手動コマンド（`supabase db push` 等）で行うことは、オペミスと不整合の元凶であり**完全禁止**とします。
        *   **CI/CD Only**: デプロイは必ず「検証されたコード」が「信頼されたパイプライン（GitHub Actions）」を通過した結果としてのみ実行されなければなりません。ヒューマンエラーを排除します。
    *   **The Architectural Preservation Protocol (Code Sanctuary)**:
        *   **Context**: 自動リファクタリングや掃除タスクによる、重要コア機能の誤削除（Friendly Fire）を防ぐ必要があります。
        *   **Action**: プロジェクトの中核機能（Core Features）を構成するファイルには、先頭に **`@preservation_level CRITICAL`** ヘッダーを付与してください。このマークがあるファイルに対し、AIは独断での削除・移動・破壊的変更を行ってはなりません。必ずユーザーの明示的承認を得てください。

*   **セキュリティ**:
    *   APIキー等の機密情報は絶対にコミットせず、`.env` を使用します。CIでシークレットスキャン（TruffleHog）を義務付けます。
    *   **The Lockfile Regeneration Reflex (CI Consistency)**:
        *   **Problem**: ローカル環境（macOS）で `build/lint` が通過しても、CI環境（Linux）で失敗する場合、原因の9割は `package-lock.json` の不整合（OS間差異や未コミットの更新）です。
        *   **Action**: CIのみが失敗する現象に遭遇したら、調査に時間をかける前にまず `rm -rf package-lock.json node_modules && npm install` を実行し、Lockfileを再生成してプッシュしてください。依存関係ツリーの完全な同期こそが、環境差異バグを撲滅する唯一の手段です。
    *   **The Connection Verification Protocol (Env Awareness)**:
        *   **Problem**: "Connection Refused" などのエラー発生時、Dockerの起動忘れを疑う前に、環境変数ファイルの接続先を確認しないミスが多発します。
        *   **Action**: データベース接続エラー発生時は、解決策を提示する前に必ず `.env.local` の `NEXT_PUBLIC_SUPABASE_URL` を確認し、**「現在どこに繋ごうとしているか（Target）」** を特定することを義務付けます。推測によるユーザー指示は禁止します。
    *   **The Dependency Override Protocol (依存関係オーバーライド)**:
        *   **Law**: `legacy-peer-deps=true` は全ての依存関係チェックを無効化する「法治国家の放棄」であり憲法違反とします。
        *   **Action**: React 19等の互換性エラーが出た場合は、`package.json` の `overrides` フィールドを使用し、「どのライブラリを」「どのバージョンとして扱うか」を明示的に定義してください。依存関係の例外処理をコード（`package.json`）としてガバナンス下に置きます。

### 10.2. The IPv6 Deployment Protocol (Rule 38.7)
*   **Law**: GitHub Actions 等のCI環境において、Supabase (PostgreSQL) への接続が IPv6 名前解決の不備により失敗する現象（Connection Refused）を、アプリケーションのコード修正で解決しようとしてはなりません。
*   **Action**:
    1. **Connection Pooler**: 必ず `supabase link` を使用し、Connection Pooler (IPv4) 経由の接続を確立してください。
    2. **DNS Bypass**: 必要に応じて、ランナー環境の `/etc/hosts` に DB ホスト名と IP を直書きするか、`SUPABASE_DB_URL` を直接指定する「インフラレベルの解決」を優先してください。

### 10.3. The Branch Hygiene Mandate (Garbage Collection)
*   **Law**: 作業ブランチを放置することは、環境差異による事故（コンフリクト、誤爆）の最大の原因です。「マージされたら削除」はエンジニアの呼吸です。
*   **Action**:
    *   **Before Final Notify**: タスク完了報告（Final Notify）の直前に、必ず `git branch --merged` を確認し、マージ済みの作業ブランチを自動的に削除してください。
    *   **Local Cleanup**: リモートブランチはGitHub側で自動削除させますが、ローカルには死骸を残さないようにします。「作りっぱなし」はエンジニアとして恥ずべき行為です。

### 10.4. The Migration Immutability Protocol (History Protection)
*   **Law**: 将来の実装予定（Blueprint）にあるカラム名を、実際のDBマイグレーション完了前にコード（Queries）で使用することは、ページ全体をクラッシュさせるため禁止です。
*   **Action**:
    *   **Trust**: クエリで使用するカラムは、必ず「現在、確実に存在する」ものに限定してください。
    *   **Fallback**: 未実装機能のデータは、DBから引くのではなく、アプリケーション層で定数（Default Config）として補完してください。

### 10.5. The Version Alignment Protocol (Zod/RHF)
*   **Law**: `zod`, `react-hook-form`, および `@hookform/resolvers` のバージョン不整合は、静的解析では検知しにくい「ランタイムでのバリデーション不全」や「不可解な型エラー」を引き起こします。
*   **Action**: フォーム関連のライブラリを導入・更新する際は、必ずこれら3者のエコシステム内での互換バージョンを確認し、一括でアップデートを行ってください。
*   **No "as any"**: バージョン不整合による型エラーを `as any` で握りつぶすことは禁止です。根本原因であるバージョン乖離を解決してください。

### 10.6. The Zod Nullable DB Alignment Protocol（DB NULL対応義務）
*   **Law**: DBスキーマで `NULL` を許容するカラムに対応するZodスキーマは、`.optional()`（`undefined` を許容）ではなく **`.nullable()`**（`null` を許容）を使用しなければなりません。
*   **Action**:
    1.  **Schema Parity**: DBカラムが `DEFAULT NULL` または `NOT NULL` 制約なしの場合、対応するZodフィールドは `z.string().nullable()` のように `.nullable()` を適用してください。`.optional()` は `undefined` を許容しますが、DBの `NULL` とは意味が異なります。
    2.  **Transform Awareness**: DBからの取得値が `null` であり、UI側で `undefined` として扱う必要がある場合は、`.nullable().transform(v => v ?? undefined)` で明示的に変換してください。暗黙の変換に依存してはなりません。
    3.  **Migration Sync**: DBマイグレーションで `NOT NULL` 制約を追加・削除した場合、対応するZodスキーマの `.nullable()` / `.required()` を**同時に更新**してください。不一致はランタイムバリデーションエラーの直接原因です。
*   **Rationale**: `null`（値が存在しない）と `undefined`（値が設定されていない）はJavaScript/TypeScriptにおいて異なる概念です。DBは `NULL` を返すのに対しZodが `.optional()` で定義されていると、バリデーションが通るが型が不正確になり、予期しない挙動を引き起こします。
## 11. ドキュメント運用 (Documentation Ops)
*   **Living Documentation**:
    *   **Mermaid.js**: アーキテクチャ図は画像ではなくコード（Mermaid）で管理し、陳腐化を防ぎます。
    *   **ADR**: 技術的な意思決定は `docs/adr` にMarkdownで記録します。
*   **The Live Docs Requirement (DX)**:
    *   **Visibility**: APIエンドポイント定義は `/api/docs` 等で Swagger UI や ReDoc を通じて常時可視化されなければなりません。隠されたAPIは負債です。
    *   **Sync**: 実装とドキュメントの乖離は許されません。tsoa, Swagger JSDoc, または AIによる自動解析を用い、コードベースから自動生成または動的配信される仕組み（Live Docs）を維持してください。
*   **Docs as Code**:
    *   ドキュメントはコードと等価であり、Gitで管理し、PRレビューの対象とします。ドキュメント更新なきコード変更はマージ禁止です。
*   **鮮度維持**:
    *   リンク切れチェックを自動化し、主要ルールは四半期ごとに見直します。
*   **The README Standard Protocol（README必須セクション基準）**:
    *   **Law**: プロジェクトのREADME.mdには以下のセクションを必ず含め、新規参画者が初日に開発環境を構築しPRを出せる状態を維持してください。
    *   **必須セクション**:
        | セクション | 内容 |
        |:---------|:-----|
        | **概要** | プロジェクトの目的（1-2文） |
        | **技術スタック** | 主要フレームワーク・ライブラリ一覧 |
        | **ローカル開発** | `npm install` → `npm run dev` の手順 |
        | **環境変数** | `.env.example` の全変数と説明 |
        | **ディレクトリ構成** | 主要ディレクトリの役割表 |
        | **デプロイ** | 本番デプロイまでのフロー |
    *   **更新義務**: 機能追加・アーキテクチャ変更時に関連ドキュメントの更新をPRチェックリストに含めてください。「コードが読めれば分かる」は禁止です。

## 12. エンジニアリング品質プロトコル (Engineering Quality Protocols)

### 12.1. The Zero-Warning Lint Protocol
*   **Law**: 「Warningなら無視しても動く」という甘えは品質低下の元です。CI全通過の真の意味は、警告数0です。
*   **Action**: `npm run lint` の結果は、必ず警告数0（Zero Warnings）でなければなりません。未使用変数は即座に削除してください。

### 12.2. The Clean Import Protocol
*   **Law**: `import` ステートメントは必ずファイルの最上部（Top-Level）に記述してください。
*   **Action**: 関数や制御フロー内でのインポートは厳禁です。どんなに急いでいても、インポートはファイルの先頭に移動させてください。

### 12.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: 開発者の「常識」はユーザーの「専門用語」です。
*   **Action**: 管理画面上の専門用語や指標には必ず `Tooltip` を付与し、「それが何であり、ビジネスにどう影響するか」を素人の言葉で解説してください。

### 12.4. Localization First Protocol
*   **Action**: エラーメッセージやバリデーションメッセージは、全て（Zodカスタムエラー等も含め）日本語化してください。

### 12.5. The Recursive Logic Ban (Infinite Recursion Shield)
*   **Law**: コンポーネントツリーやビジネスロジック内での、終了条件が不明確な「深い再帰処理（Deep Recursion）」を禁止します。
*   **Reason**: スタックオーバーフローを引き起こすだけでなく、不注意な実装（useEffect等との組み合わせ）により無限DB読み込みを誘発し、クラウド破産を招くためです。
*   **Action**: 再帰的な構造（木構造の表示等）を扱う場合は、必ず **Depth Limit (最大深度)** を定数（例: `MAX_DEPTH = 5`）として定義し、それを超える場合は例外をスローするか、フラットなデータ構造への変換（Normalization）を検討してください。

### 12.6. The Atomic Commits Protocol（原子的コミット基準）
*   **Law**: 1つのコミットには「1つの論理的変更」のみを含めてください。フォーマット修正と機能追加を混在させてはなりません。
*   **Revertability**: バグ発生時に「そのコミットだけ」をRevertすれば修正される粒度を維持してください。
*   **Prohibition**: WIP（Work In Progress）コミットの本番ブランチへのプッシュを禁止します。作業途中のコミットは、マージ前にSquashで整理してください。

### 12.7. The Conventional Commits Standard（セマンティックコミット規約）
*   **Law**: コミットメッセージは `type(scope): subject` 形式を遵守してください。AI・ツールによる履歴解析やChangelog自動生成の精度を高めるために必須です。
*   **Types**:
    | Type | 用途 |
    |:-----|:-----|
    | `feat` | 新機能追加 |
    | `fix` | バグ修正 |
    | `refactor` | リファクタリング（機能変更なし） |
    | `perf` | パフォーマンス改善 |
    | `docs` | ドキュメント変更 |
    | `style` | コードスタイル変更（フォーマット等） |
    | `test` | テスト追加・修正 |
    | `chore` | ビルド・CI設定変更 |
    | `security` | セキュリティ修正 |
*   **Breaking Change**: 破壊的変更がある場合は `feat!:` または footer に `BREAKING CHANGE:` を記載してください。

### 12.8. The Code Review Protocol（コードレビュー基準）
*   **Law**: コードレビューは品質の最終防衛線であり、属人化防止と知識共有の機会でもあります。
*   **PRサイズ**: 変更行数は **400行以下** を目安とします。超過する場合はPRを分割してください。
*   **レビュー観点チェックリスト**:
    | 観点 | チェック内容 |
    |:-----|:-----------|
    | **型安全性** | `as any` の使用禁止、適切な型定義 |
    | **セキュリティ** | PII露出なし、アクセス制御確認 |
    | **パフォーマンス** | N+1クエリなし、不要な再レンダリングなし |
    | **FinOps（コスト影響）** | 無限ループDB読み込みなし、キャッシュ戦略適切、AIトークン浪費なし |
    | **国際化・ローカライズ** | UI文言が運用者の母国語で記述されているか |
    | **アクセシビリティ** | キーボード操作可能、`aria-label` 適切 |
*   **セルフレビュー**: PR作成者は提出前に上記チェックリストを自己確認し、PRテンプレートに記入してください。

### 12.9. The CODEOWNERS Protocol（コード所有権管理）
*   **Law**: コードベースの拡大に伴い、各領域の責任者を明確化してください。適切なレビュアーの自動アサインにより品質と速度を両立します。
*   **Action**:
    1.  `.github/CODEOWNERS` ファイルでディレクトリごとの所有者を定義してください。
    2.  CODEOWNERSに指定された所有者のApproveをPRマージの必須条件としてください（Branch Protectionで強制）。
    3.  チームメンバーの追加・退出時にCODEOWNERSを即時更新してください。
    4.  新規ディレクトリ作成時はPRで所有者を明示してください。
*   **Rationale**: 所有者が不明確なコードは、誰もレビューせず品質が低下します。「自分の領域」という責任感が品質を支えます。

### 12.10. The Git Hooks Automation Protocol（Git Hooks自動化三層防御）
*   **Law**: 「気をつける」という運用ルールではなく、「物理的に不可能にする仕組み（Code not Policy）」で品質を担保してください。
*   **三層防御**:
    | レイヤー | フック | 内容 | ツール例 |
    |:---------|:-----|:-----|:--------|
    | **Pre-Commit** | `pre-commit` | ステージングされたファイルに対してLint・フォーマットを自動実行 | `husky` + `lint-staged` |
    | **Commit-Msg** | `commit-msg` | コミットメッセージがConventional Commits形式に準拠しているか検証 | `commitlint` |
    | **Pre-Push** | `pre-push` | 保護ブランチ（`main`, `master`）への直接Pushを物理的にブロック | ブランチ名チェックスクリプト |
*   **Action**:
    1.  プロジェクト初期化時にGit Hooks管理ツールを導入してください。
    2.  Pre-pushフックでカレントブランチを検査し、保護ブランチ名に一致する場合は `exit 1` で強制中断してください。
    3.  `--no-verify` でのフック迂回は、ゼロトレランス（Zero Tolerance）とし禁止です。
*   **Rationale**: サーバー側のBranch Protectionだけでは、ローカルでの誤Pushを防げません。クライアント側とサーバー側の二重防御（Defense in Depth）が必要です。

### 12.11. The Branch Naming Convention（ブランチ命名規約）
*   **Law**: ブランチ名は `type/summary` 形式で統一してください。履歴の可読性と自動化ツールとの連携のため必須です。
*   **Types**: `feat/`, `fix/`, `refactor/`, `chore/`, `hotfix/`
*   **Example**: `feat/user-profile`, `fix/login-redirect-loop`, `refactor/dto-cleanup`
*   **Merge Strategy**: PR作成時は **Squash Merge** を前提とし、コミット履歴を汚さないでください。
*   **Branch Cleanup Protocol（マージ後クリーンアップ）**:
    1.  `git checkout main` で作業ブランチから離脱してください。
    2.  `git pull origin main` でローカルの `main` を最新化してください。
    3.  マージ済みブランチは即座に削除してください。放置されたブランチは「技術的負債」です。
*   **Rationale**: 一貫性のないブランチ名は、CI/CDパイプラインやリリースノート自動生成を破壊し、履歴の追跡を困難にします。

### 12.12. The SSOT Sync Protocol（SSOT同期プロトコル）
*   **Law**: 作業ブランチのマージ完了後、またはブランチから離脱した際は、必ずローカルの `main` ブランチをリモートの状態と**100%同期**させなければなりません。ローカルの `main` は常に「Single Source of Truth（唯一の正解）」と一致していなければなりません。
*   **Action**:
    1.  **Post-Merge Sync**: 作業完了時は以下を実行してください：
        *   `git checkout main`
        *   `git pull origin main`
        *   マージ済みブランチの削除
    2.  **Pre-Task Verification**: 新規タスクを開始する際は、まずローカルの `main` が最新であることを確認してください。古い状態からのブランチ作成は、コンフリクトと手戻りの元凶です。
    3.  **No Stale Development**: 古い `main` からブランチを切って開発を開始することを禁止します。`git log --oneline -1 origin/main` と `git log --oneline -1 main` の一致を確認してください。
*   **Rationale**: ローカルとリモートの乖離は、マージコンフリクト、既に修正済みのバグへの対応、そして環境差異による予期しない動作の主原因です。「同期忘れ」を「プロセスの欠陥」として制度化することで、この種の事故を構造的に防止します。

## 13. 高度アーキテクチャ原則 (Advanced Architectural Mandates)


### 13.1. The Trinity DTO Mandate (Constitutional Pillar)
*   **Law**: いかなる機能実装においても、以下の3点を遵守しないコードは、存在自体が憲法違反（Unconstitutional）となり、即時削除の対象となります。
    1.  **Security (PII Defense)**: 生データ（Raw Row）の出力は禁止です。必ず **DTO (White-list)** を経由し、機密情報を物理的に遮断してください。
    2.  **Stability (Frontend Shield)**: DBスキーマとUIを直結させてはなりません。Mapper関数という「防波堤」を築き、変更の影響をサーバー内で吸収してください。
    3.  **AI Economy (Token Optimization)**: AIに無駄なデータを読ませてはなりません。**AI-Optimized DTO** でトークンを極限まで節約し、推論精度を高めてください。
*   **Detailed Action**:
    *   **Strict Segregation**: 機密性の高いフィールド（管理者の内部メモ、PII等）を含むDTOは、必ず `AdminDTO` / `PublicDTO` のように型レベルで物理的に分離し、誤インポートを物理的に防止してください。
    *   **No Raw Return**: Server ActionsやAPIは、生の `Database['public']['Tables']` 型を返してはなりません。必ず明示的に定義されたDTO型を返してください。
    *   **No Blind Spread (The Spread Prohibition)**: `...user` のようなスプレッド構文でのプロパティコピーは、将来追加される機密カラム（例: `internal_memo`, `password_hash`）を意図せず漏洩させるため、DTO変換層では**完全禁止**とします。必ず明示的にフィールドを列挙してください。`as any` による握りつぶしも「セキュリティ犯罪」とみなします。
    *   **No Dynamic DTO**: Server Actions内でDTOMapper関数を動的インポート（`await import`）することは、型安全性と契約（Contract）の安定性を損なうため禁止します。常に静的インポート（Static Import）を使用してください。
    *   **The Return Type Clarity Protocol (Wrapper Ban)**:
        *   **Law**: Server Actionsの戻り値型において、成功時に `{ data: T[] }` のような無意味なラッパーオブジェクトを使用することを禁止します。
        *   **Standard**: 成功時は `T` または `T[]` を直接返し、エラー時は `throw` または `null` を返すパターンに統一してください。呼び出し側での `res.data` アクセスによる混乱（undefined参照）を防ぎます。
    *   **The UI-DTO Binding Protocol (Component Contract)**:
        *   **Law**: 共有UIコンポーネント（Card, Widget等）のPropsは、具体的なDB型（`Database['public']['Tables']['...']`）ではなく、**抽象化されたDTOインターフェース**に依存させなければなりません。
        *   **Reason**: 異なるデータソース（例：人気リストと検索結果）で同じUIを再利用可能にするためです。これによりOmnichannelアーキテクチャを実現します。

### 13.2. The Client DB Access Prohibition (Architecture Law)
*   **Law**: クライアントサイド（React Components）から `supabase.from()` を直接呼び出すことは、RLSポリシーの実装漏れや生データ漏洩（DTO未適用）を招くため、アーキテクチャレベルで禁止します。
*   **Action**:
    *   **Gateway First**: データ取得・更新は必ず `Server Actions` または `Route Handler` (API) を経由してください。
    *   **Secure Write Action Protocol (The Turnstile Mandate)**:
        *   **Law**: 公開フォーム（Auth, Inquiry, Review等）への書き込みを行う Server Action は、必ず `turnstileToken` を引数として受け取り、サーバーサイドで検証することを義務付けます。
        *   **Verification**: 検証を通過しないリクエストは、DBに到達する前に `400 Bad Request` で即時却下してください。
    *   **Exception**: 認証 (`auth`), Realtime購読, Fire-and-forgetなRPC（閲覧数カウント等）のみ例外として許可されます。

### 13.3. The Service Pattern Mandate (Server Component Gateway)
*   **Law**: `page.tsx` や `layout.tsx` 等のServer Component内で、DBアクセス関数（`supabase.from()`等）を直接呼び出すことを禁止します。
*   **Reason**: Omnichannelアーキテクチャにおいて、同じデータ取得ロジックがWeb（Server Component）、モバイルアプリ向けAPI (`/api/v1/*`)、管理画面などから100%再利用可能でなければなりません。
*   **Action**: 必ず `lib/api/gateways/` (Read) または `lib/actions/` (Write) にロジックを抽出し、UIは「Gatewayを呼んで表示するだけ」の状態にしてください。

### 13.4. The VIP Lane Strategy (Native Bypass Protocol)
*   **Context**: 自社開発ネイティブアプリからのAPIアクセスに対し、外部パートナー向けAPI Keyを必須にすると、アプリ内に秘密鍵を埋め込むセキュリティリスクが発生します。
*   **Law (Dual Auth Strategy)**:
    1.  **Common Endpoint**: 読み取りAPIエンドポイントは、Public（他社）とFirst Party（自社）で共有します。
    2.  **Dual Auth**: Middlewareにおいて「API Key認証」と「Bearer Token認証」のOR条件を実装してください。
    3.  **Tier Grant**:
        *   `X-API-KEY` のみに依存するリクエスト → キーに紐付いたTier (Tier 1/2) を適用。
        *   `Authorization: Bearer` (User Session) を持つリクエスト → 正当なログインユーザーであれば、無条件で特権Tierを付与します。
*   **Outcome**: アプリに秘密鍵を持たせず（No Secrets）、ログインユーザーであること（Trust）を担保にVIPレーンを確立します。

### 13.5. The Centralized Logging Protocol (Zero Console)
*   **Law**: 本番環境における `console.log` や `console.error` の放置は「衛生管理欠如」です。構造化されていないログは検索不能であり、ノイズです。
*   **Action**:
    *   **Logger Only**: APIやAction内では、必ず `src/lib/logger.ts` (Logger) を使用してください。
    *   **Prohibition**: `console.*` メソッドの使用を禁止します（Linterでブロック推奨）。

### 13.6. The Pragmatic Casting Protocol (Type Survival)
*   **Context**: 自動生成された型定義（`Database`）にまだ存在しないテーブル（Phantom Tables）へのアクセスが必要な場合、CIを通すために一時的なバイパスが必要です。
*   **Law**: `as any` は禁止ですが、意図的なブリッジキャストは許容します。
*   **Action**:
    *   **Local Extension**: 不足している型定義を `src/types/database-extensions.ts` に局所定義してください。
    *   **Bridge Pattern**: `(supabase as any).from('table')` を許容し、戻り値を直後に `data as MyLocalRow[]` とアサーションすることで、実用的な型安全性を確保してください。ただし、これは正規の型定義が生成されるまでの**一時的な処置**としてください。

### 13.7. The Unstable Timer Protocol (SetTimeout Ban)
*   **Law**: `setTimeout` や `setInterval` は実行タイミングが保証されず、サーバーレス環境（Edge）や高負荷時にシステムを不安定にします。
*   **Action**: ロジック制御のためにタイマーを使用することを禁止します。必要な場合はイベント駆動アーキテクチャ、ジョブキュー（Background Jobs）、または `requestAnimationFrame` を使用してください。

### 13.8. The Type Bridge Mandate (No Implicit Any)
*   **Law**: 自動生成型（`database.types.ts`）に不足がある場合でも、`as any` で逃げることは許されません。「ビルドが通る」と「型が安全」は別物です。
*   **Action**:
    *   **Extension**: `src/types/database-extensions.ts` に拡張型 (`DatabaseExtended`) を定義し、不足しているViewやRPCを補完してください。
    *   **Bridge**: Supabaseクライアント初期化時にこの拡張型をジェネリクスとして渡し、アプリ全体で型安全性を維持してください。
    *   **Mapped Type**: 拡張型を定義する際は、交差型（`&`）ではなく **Mapped Type (写像型)** を使用し、型衝突による `never` や `undefined` への退化を防いでください。

### 13.9. The API Product Mindset (Data Monetization Protocol)
*   **Law**: 全てのデータ出力は「商品（Product）」です。「Internal APIだから」という甘えは、セキュリティと収益化の機会を損ないます。
*   **Action**:
    *   **Strict Tiering**: APIは必ず **Tier 1 (Public/Free)** と **Tier 2 (Enterprise/Paid)** に分離できる設計にしてください。
    *   **Usage Recording**: 全ての Enterprise API エンドポイントにおいて、成功時に `recordApiUsage` を **Fire-and-forget** パターンで呼び出し、使用量を監査ログに残してください。
    *   **Metadata**: レスポンスには `meta` フィールド（AI用メタデータ、Tier情報、生存期間TTL）を含め、AIエージェントの自律判断を支援してください。
    *   **Metadata Segregation Protocol (Stripe vs App)**:
        *   **Law**: Stripe等の外部決済プロバイダの `metadata` フィールドと、アプリ内部の `metadata` カラムを混同・同期することは、上書き事故の元凶であり厳禁とします。
        *   **Action**: 決済メタデータには `app_` 接頭辞（例: `app_user_id`）を付与し、プロバイダ固有キー（`subscription_id`等）との衝突を物理的に回避してください。
    *   **Standard Metadata**: Tier 1/2 の API においては、メタデータ内に `tier` (public, enterprise), `usage` (metered, unlimited), `revalidation` (ttl) 等の情報を付与し、FinOps最適化を支援してください。
    *   **The API Latency Budget (Rule 26.5)**:
        *   **Law (Speed First)**: 全ての Public/Enterprise API の TTI (Time to Interaction) は、**200ms 以内** に抑えることを設計目標とします。
        *   **Action**: 200ms を超える処理（重い集計、外部API連携）は、同期的に行わず Webhook または非同期 Queue に逃がし、API は `202 Accepted` と `request_id` を即座に返却してください。

### 13.10. The Tenant-Aware Naming Protocol
*   **Law**: 将来的なSaaS化（マルチテナント）を見据え、リソース名は明確に区別します。
*   **Action**:
    *   **Site/Tenant**: 顧客（テナント）ごとの設定やリソースには `site_` や `account_` を接頭辞として使用します（例: `site_settings`）。
    *   **System**: 全テナント共通の不変な基盤設定にのみ `system_` を使用します。これにより `tenant_id` 追加時の設計破綻を防ぎます。

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

### 13.22. The Omnichannel Delivery Mandate（オムニチャネル提供義務）
*   **Law**: UIコンポーネント（`page.tsx`, `layout.tsx` 等）にビジネスロジックやデータアクセスを直接記述することを禁止します。全てのデータ取得・更新・集約ロジックは **Service層またはGateway層** に抽出し、型安全なインターフェースとして提供してください。
*   **Rationale**: Web UIに密結合したロジックは、モバイルアプリ、AIエージェント、外部APIからの再利用が不可能な「Web専用レガシーコード」となります。ロジックをService/Gateway層に集約することで、全チャネルから一貫した振る舞いを保証できます。
*   **Action**:
    1.  **UI = Thin Controller**: UIコンポーネントはService/Actionの呼び出しとプレゼンテーションのみに専念してください。DBクライアントの直接参照は禁止です。
    2.  **Service Aggregation**: 複数のGateway/Actionを統合して1画面分のデータを生成する「集約ロジック」は、必ずService層に `get...Data()` 形式で抽出してください。
    3.  **DTO Response Only**: Service/Actionの戻り値は必ずDTOに変換し、生のDBレコードをUI層に返却しないでください。
*   **Anti-Pattern**: `page.tsx` 内で `supabase.from('table').select()` を直接呼び出す行為は、アーキテクチャの根幹への違反です。

### 13.23. The Zero Defect Sovereignty（ゼロ欠陥主権）
*   **Law**: 型チェック（`tsc --noEmit` 等）およびLinter（`eslint`, `biome` 等）が **警告ゼロ（Exit 0）** で通過しないコードのコミットを禁止します。
*   **Action**:
    1.  **Local First**: コミット前にローカルで型チェックとLintを実行し、ゼロ警告を確認してください。CIでの検出に頼る運用は遅延の原因です。
    2.  **No Escape Hatches**: `as any`、`@ts-ignore`、`@ts-nocheck` は「警告の抑制」ではなく「バグの埋め込み」です。使用を原則禁止とし、使う場合は根拠をコメントで明記してください。
    3.  **Zero Tolerance**: 「今は無視して後で直す」は許容しません。警告が出たらその場で解決してください。
*   **Rationale**: 型エラーやLint警告を放置すると、スキーマ変更時に「ビルドは通るが実行時にクラッシュする」時限爆弾が埋め込まれます。ゼロ欠陥は品質の最低基準であり、目標ではありません。

### 13.24. The Linter Suppression Prohibition（Linter抑制コメント禁止）
*   **Law**: `eslint-disable` / `eslint-disable-next-line` / `@ts-ignore` / `biome-ignore` 等のLinter抑制コメントの使用を原則禁止とします。
*   **Exception**: 外部ライブラリとの互換性問題など、根本解決が不可能な場合のみ許可します。その場合も：
    1.  抑制の理由を具体的にコメントで明記してください。
    2.  対応する Issue を作成し、将来の根本解決を追跡してください。
*   **Rationale**: 抑制コメントは問題を「見えなくする」だけであり、根本原因を次の開発者に押し付ける行為です。警告が出たら、抑制ではなく根本原因を解決してください。
*   **Anti-Pattern**: 「将来使うかもしれない」変数を `eslint-disable` で黙らせて残すのは、不要コードの温存であり禁止です。使う時に書いてください。

### 13.25. The Structured Error Return Protocol（構造化エラー返却）
*   **Law**: バックエンドAPIやサーバーアクションは、原則として例外（`throw`）を投げるのではなく、**`{ success: boolean; data?: T; error?: string }` 形式の構造化されたレスポンス**を返さなければなりません。
*   **Action**:
    1.  **No Raw Throw**: バリデーションエラーや権限不足などの「予期されるエラー」に対して `throw new Error()` を使用しないでください。`throw` はフロントエンドの状態管理フック（`useActionState` 等）を「予期せぬ例外」として処理させ、コンポーネントのクリーンアップや再試行ロジックの暴走を招きます。
    2.  **Graceful Failure Contract**: エラー発生時は `{ success: false, error: 'human-readable message' }` を返し、フロントエンド側でトーストやインラインメッセージとして表示してください。
    3.  **Server-Client Symmetry**: サーバーサイドのガード強化（認証チェック追加等）を行う際は、必ずフロントエンド側の「エラー受け取り口」を同時に整備してください。片側だけの強化は、システム全体のクラッシュに昇格するリスクがあります。
*   **Rationale**: 「予期されるエラー」を `throw` で返すと、フロントエンドフレームワークの例外処理機構が介入し、無限再レンダリングループやページ全体のクラッシュを引き起こします。構造化されたレスポンスは、エラーハンドリングの制御権をフロントエンド開発者に委ね、システムの安定性を保証します。

### 13.26. The Cache Invalidation Ceremony Protocol（キャッシュ無効化儀式）
*   **Law**: コアクエリロジック（フィルタ条件、プロジェクション仕様、可視性ガード等）を変更した場合は、**ビルドキャッシュの物理削除と開発サーバーの完全再起動**を義務付けます。
*   **Action**:
    1.  **Full Environment Reset**: クエリロジック変更後は、ビルドキャッシュディレクトリ（`.next/`, `dist/`, `.cache/` 等）を物理削除し、開発サーバーを再起動してください。
    2.  **Kill Process**: プロセスの graceful shutdown では不十分な場合があります。`kill -9` 等で強制終了し、クリーンな状態から再起動してください。
    3.  **Pre-Verification**: キャッシュクリア後にのみ、変更の効果を検証してください。キャッシュの残留は「コード変更が反映されていない」という誤った結論を導きます。
*   **Rationale**: 多層キャッシュ戦略（メモリキャッシュ、ファイルキャッシュ、CDNキャッシュ等）を採用しているアプリケーションでは、コード変更後もキャッシュが古いデータを提供し続ける可能性があります。これにより「コードは正しいのに動作しない」という誤診が発生し、不要なデバッグに膨大な時間を浪費します。

### 13.27. The Projection-Schema Parity Mandate（射影スキーマ同期義務）
*   **Law**: データ取得時の射影仕様（Select Specification、GraphQLフラグメント等）は、物理的なDBスキーマと **100%一致** しなければなりません。UIやDTOに定義されているがDBに存在しない「幽霊フィールド（Phantom Fields）」は、実行時のサイレントクラッシュの直接原因です。
*   **Action**:
    1.  **Vertical Synchronization Audit**: 新しいフィールドを追加する際は、**DB Schema → DTO → Gateway → UI Interface** の全レイヤーを垂直に検証してください。一つのレイヤーにのみフィールドが存在する状態は許容しません。
    2.  **Ghost Hunt Protocol**: 射影仕様に含まれるフィールドが「column does not exist」エラーを引き起こした場合、そのフィールドだけでなく、仕様全体を物理スキーマと照合する「再帰的ゴースト監査」を実施してください。1つの不一致は、システム的なドリフトのシグナルです。
    3.  **No Speculative Fields**: DBに未実装のフィールドを「将来的に必要だろう」という予測でDTOやUIに定義しておくことは禁止です。使用時に実装してください。
*   **Rationale**: 射影仕様パターン（Select Specification等）はPII漏洩防止やAPI課金制御に強力ですが、スキーマとの「結合リスク」を内在します。DBから返されないフィールドへのアクセスは、フロントエンド全体をクラッシュさせる不可視のバグとなります。

### 13.28. The Mutation Integrity Verification Protocol（ミューテーション整合性検証）
*   **Law**: データ書き込み操作（Create/Update/Delete）において、**`error: null` は成功を意味しません**。影響行数（`count` / `affectedRows`）を常に検証し、0行の場合は明示的にエラーを投げてください。
*   **Action**:
    1.  **Count Validation**: ID指定の単一レコード操作（`WHERE id = ?`）では、影響行数が `1`（または期待値）であることを必ず検証してください。`0` の場合は「権限不足」または「レコード不在」のシグナルとして明示的エラーをスローしてください。
    2.  **Sub-Step Integrity**: 一つのトランザクション的な処理内で複数の書き込み操作（メインテーブル更新 → リレーション更新 → タグ更新等）を行う場合、各ステップのエラーオブジェクトを個別に検証してください。途中のステップが失敗しても最終結果が「成功」を返す「Partial Phantom Success」を防いでください。
    3.  **Post-Mutation Verification Fetch**: 特に重要度の高い更新（画像の並び替え、ステータス変更等）では、更新直後に同じIDで再取得（`SELECT`）を行い、現在値をログ出力またはアサーションしてください。これにより「DB書き込み失敗」と「UI表示失敗（キャッシュ）」を100%切り分けられます。
*   **Rationale**: 多くのDBクライアント/ORM（特にRLS対応のもの）は、権限不足によりアクセスを拒否された場合でも、エラーを投げずに「0行に影響した成功レスポンス」を返す仕様があります。この「サイレント拒否」は、UIに偽の成功メッセージを表示させ、データの不整合を検知不能にします。

### 13.29. The Service Aggregation Protocol（サービス集約プロトコル）
*   **Law**: 複数のGateway/Repository/Actionを呼び出して1画面（1ページ）分のデータを組み立てる「集約ロジック」は、**Service層に抽出**しなければなりません。UI層（ページコンポーネント、コントローラー）は、Serviceを呼び出すだけの薄いエントリーポイントに徹してください。
*   **Action**:
    1.  **Single Responsibility**: 1つのページに5つ以上のデータソースからフェッチしている場合、それは「ページがService層の仕事をしている」シグナルです。`XxxService.getPageData()` に集約してください。
    2.  **Testability**: Service層はPure Functionまたは注入可能な依存関係のみで構成し、UI/フレームワーク依存を持たないでください。これにより単体テストが可能になります。
    3.  **Reusability**: 同一データセットを複数のUI（管理画面、公開ページ、API）から利用する場合、Serviceを共有することで「同じデータの別解釈」を防止してください。
*   **Rationale**: UI層にデータ集約ロジックが散在すると、同一データへのアクセスパスが複数生まれ、キャッシュ戦略やエラーハンドリングの統一が不可能になります。Service層は「ビジネスロジックの正門」として機能します。

### 13.30. The Production Build Verification Protocol（本番ビルド検証義務）
*   **Law**: 開発サーバー（`dev` モード）が動作していることは、コードの正しさの証明には**なりません**。型チェック（`tsc --noEmit`）および本番ビルド（`npm run build` 等）が通過するまで、そのコードは「存在しない」ものとして扱ってください。
*   **Action**:
    1.  **Mandatory Triple Crown**: タスク完了前に以下の3つのチェックを必ず通過させてください。
        *   ① 型チェック（`tsc --noEmit`）: 型エラーゼロ
        *   ② リンター（`eslint --max-warnings=0`）: 警告ゼロ
        *   ③ 本番ビルド（`npm run build`）: ビルド成功
    2.  **PR Rejection**: 上記3点の通過結果が提示されていないPRは即時却下してください。
    3.  **Dev Mode Trap**: `dev` モードではHot Module Replacement（HMR）やランタイムエラーの遅延評価により、本番では発生するエラーが隠蔽されます。`import` の解決、Tree Shaking、SSRパスの実行は `build` でのみ完全に検証されます。
*   **Rationale**: 開発サーバーは「寛容すぎる」環境です。本番ビルドは、デッドインポートの検出、SSRパスのクラッシュ、動的ルートの型不整合など、開発モードでは沈黙するエラーを顕在化させる唯一の手段です。

### 13.31. The CI/CD Environment Gap Protocol（CI/CD環境乖離プロトコル）
*   **Law**: CI環境は「空のデータベース（Clean Room）」でテストを実行するため、**既存データとの衝突**（ユニーク制約違反、外部キー不整合、NOT NULL制約のデフォルト値不足等）を検知できません。データ操作を含む変更は、本番データとの衝突を前提とした防衛的コードで記述してください。
*   **Action**:
    1.  **Defensive DML**: `INSERT` 文には `ON CONFLICT ... DO UPDATE` または `DO NOTHING` を使用し、冪等性を確保してください。
    2.  **Pre-Check**: `ALTER TABLE` で `NOT NULL` 制約を追加する場合、既存の `NULL` 値を事前に `UPDATE` でデフォルト値に埋めてください。
    3.  **Staging Verification**: 可能な限り、本番に近いデータを持つステージング環境でデータ変更を事前検証してください。
*   **Rationale**: CIの「全グリーン」は「無菌室での成功」に過ぎません。本番環境の複雑さ（既存データ、並行アクセス、歴史的メンテナンス負債）を忘れた時、デプロイ障害は確実に訪れます。

### 13.32. The Clean Workspace Mandate（クリーンワークスペース義務）
*   **Law**: タスク完了時、作業中に生成された一時ファイル、ビルドキャッシュ、空ディレクトリ、デバッグ用の `console.log` は**全て除去**してからコミットしてください。リポジトリは「使用後即廃棄（Scorched Earth）」の原則で常にクリーンな状態を維持します。
*   **Action**:
    1.  **Checklist**: コミット前に以下を確認してください。
        *   一時ファイル（`.tmp`, `.bak`, `*.log` 等）が残っていないか
        *   空ディレクトリ（ファイルが0個のフォルダ）が残っていないか
        *   `console.log` / `console.debug` がコードに残っていないか
        *   ビルドキャッシュ（`.next/cache` 等）がGit追跡対象に含まれていないか
    2.  **Gitignore Hygiene**: `.gitignore` にビルド出力、環境ファイル、IDE設定が網羅されていることを初期化時に確認してください。
    3.  **Branch Hygiene**: マージ済みブランチは速やかに削除してください。放置ブランチは「環境差異による事故」の温床です。
*   **Rationale**: 残置された一時ファイルやデバッグコードは、次の開発者（未来の自分を含む）に「これは意図的に残されたコードなのか？」という不要な認知負荷を与えます。クリーンなリポジトリはチーム全体の生産性に直結します。

### 13.33. The Dead Code Prohibition Protocol（デッドコード禁止プロトコル）
*   **Law**: 「将来使うかもしれない」という理由でコードを残すことは、技術的負債の最大の温床です。**現在使用されていないコード（未使用の変数、インポート、関数、型定義）は即時削除**を義務付けます。
*   **Action**:
    1.  **No Future-Use Code**: 現在の機能で使用されていないコードは、コメントアウトも含めて一切残しません。必要になった時に Git 履歴から復元してください。
    2.  **Strict Variable Hygiene**: 宣言されたが一度も参照されない変数・定数・インポートは、ビルド前に全て除去してください。`_` プレフィックスは、destructuring での明示的な値の廃棄（例: `const [_, setValue] = useState()`）にのみ許可します。
    3.  **Lint Enforcement**: ESLint の `no-unused-vars` / `@typescript-eslint/no-unused-vars` を `error` に設定し、CIで物理的にブロックしてください。
*   **Rationale**: 未使用コードは「壊れた窓」です。1つ放置すれば、チーム全体が「少しくらいなら大丈夫」と判断し、コードベース全体の品質が低下します。

### 13.34. The Warning Suppression Prohibition Protocol（警告抑制禁止プロトコル）
*   **Law**: Linter や型チェッカーの警告を**抑制・無視するディレクティブ**を安易に使用することを原則禁止します。警告は「修正すべきコードの臭い」であり、消すのではなく根本原因を修正してください。
*   **Action**:
    1.  **ESLint**: `eslint-disable`, `eslint-disable-next-line` の使用は原則禁止です。やむを得ず使用する場合は、**理由を明記したコメント**を必ず併記してください（例: `// eslint-disable-next-line -- ライブラリの型定義が不正確なため`）。
    2.  **TypeScript**: `@ts-ignore`, `@ts-nocheck`, `@ts-expect-error` の使用を原則禁止します。型エラーは型定義の修正で解消してください。
    3.  **Other Tools**: Stylelint、Prettier 等のツールについても同様に、抑制ディレクティブの使用は根本解決の後の最終手段としてのみ許容します。
    4.  **CI Enforcement**: 抑制ディレクティブの新規追加を検出する Lint ルール（例: `eslint-comments/no-unlimited-disable`）の導入を推奨します。
*   **Rationale**: 警告抑制は「問題を見えなくする」だけで解決しません。抑制コメントが増殖するとコードベースの信頼性が損なわれ、真に重要な警告が埋もれます。

### 13.35. The Type Integrity Mandate（型誠実性義務）
*   **Law**: TypeScript の型システムをバイパスする行為は「バグの埋め込み」と定義します。**`as any` による型キャストを原則禁止**し、型の正確性を最優先事項とします。
*   **Action**:
    1.  **No `as any`**: `as any` は型チェッカーを完全に無効化するため、使用を禁止します。外部ライブラリの型が不正確な場合は、`declare module` で正確な型定義を提供してください。
    2.  **Strict Action Return Types**: Server Actions、API ハンドラ、Service 関数の戻り値には、必ず明示的な型定義を付与してください。`any` や `unknown` を戻り値型として使用することは禁止です。
    3.  **No Type Assertion Chains**: `(value as unknown as TargetType)` のような多段キャストは、型安全性の破壊を示すアンチパターンです。データ変換関数を作成し、ランタイムでの検証を伴う型変換を行ってください。
    4.  **Lint Enforcement**: `@typescript-eslint/no-explicit-any` を `error` に設定してください。
*   **Rationale**: `as any` は「型チェッカーへの嘘」です。コンパイル時には問題が見えなくなりますが、ランタイムでは予期しない型のデータが流通し、デバッグ困難なバグを引き起こします。

### 13.36. The UI-Layer Data Access Prohibition（UI層直接データアクセス禁止）
*   **Law**: UIコンポーネント（ページコンポーネント、レイアウトコンポーネント、クライアントコンポーネント）から、データベースや外部APIに**直接アクセスすることを禁止**します。全てのデータアクセスは、Service層またはGateway層を経由しなければなりません。
*   **Action**:
    1.  **Service Layer Mandate**: データの取得・変更は、必ず専用の Service / Gateway / Action 関数を経由してください。UI層はこれらの関数の戻り値（DTO）のみを扱います。
    2.  **No DB Client in UI**: UIファイル内で DB クライアント（ORM、SDK等）を直接インポート・使用することを禁止します。
    3.  **DTO Boundary**: Service層は、DBのレコード構造をそのまま返すのではなく、UIが必要とするデータのみを含む**DTO（Data Transfer Object）**に変換して返してください。
    4.  **Omnichannel Readiness**: この分離により、同一の Service 層をWeb、ネイティブアプリ、外部API など複数のクライアントから再利用可能にします。
*   **Rationale**: UI層とデータ層の直接結合は、テスト容易性を破壊し、オムニチャネル展開を不可能にします。Service層を挟むことで、ビジネスロジックの集約、テストの容易化、クライアント非依存のアーキテクチャを実現します。

### 13.37. The Graceful Failure Contract（優雅な失敗の契約）
*   **Law**: サーバーサイドの処理（Server Actions、APIハンドラ等）は、業務ロジック上の失敗に対して `throw new Error()` を使用することを**原則禁止**します。代わりに、**構造化されたエラーレスポンス**（`{ success: false, error: '...' }`）を返し、クライアントサイドで適切に処理させなければなりません。
*   **Action**:
    1.  **No Raw Throw**: Server Actions が `throw` を行うと、クライアントサイドのUIフレームワーク（React の `useActionState` 等）がエラーを「予期せぬ例外」として処理し、コンポーネントのクリーンアップや再試行ロジックが暴走して無限ループを引き起こす場合があります。業務エラー（権限不足、バリデーション失敗等）は必ず構造化レスポンスとして返してください。
    2.  **Common Response Type**: 全てのサーバーアクションに共通のレスポンス型（例: `ActionResult<T> = { success: true, data: T } | { success: false, error: string }`）を定義し、クライアントが統一的にエラーを処理できるようにしてください。
    3.  **Client-Side Feedback**: クライアントサイドでは、`success: false` の場合にトースト通知やインラインエラーメッセージとして表示し、ユーザーに適切なフィードバックを提供してください。
    4.  **Exception**: `throw` の使用が許容されるのは、プログラムの継続が不可能な致命的エラー（DB接続断絶、環境設定の欠落等）のみです。
*   **Rationale**: サーバーサイドのセキュリティ強化（ガード追加等）とクライアントサイドのエラーハンドリングは「対」で整備する必要があります。サーバーだけを強化してクライアントの「エラー受け取り口」を整備しないと、正常な「権限不足エラー」がシステム全体の「無限ループクラッシュ」へと昇格するリスクがあります。

### 13.38. The Mutation Count Validation（ミューテーション影響行数検証義務）
*   **Law**: データベースへの書き込み操作（UPDATE / DELETE）の後、**影響を受けた行数（`count`）を必ず検証**しなければなりません。`error: null`（エラーなし）であっても `count: 0` は「サイレント拒否」を意味する可能性があります。
*   **Action**:
    1.  **Count Check**: ID等を指定した単一レコードの更新・削除操作において、レスポンスから `count` を必ず取得し、期待される行数（通常は `1`）であることを検証してください。
    2.  **Explicit Failure**: `count` が `0` または `null` の場合は、明示的なエラー（例: `throw new Error('Update failed: No rows affected.')`）をスローし、UIが虚偽の成功状態を表示することを防いでください。
    3.  **Instrumentation**: デバッグ時には、ミューテーション結果の `count` をログに出力し、書き込みの実効性を可視化してください。
    4.  **RLS Awareness**: Row Level Security（RLS）を使用するデータベースでは、権限不足はエラーではなく「0行に影響」として返されることを常に念頭に置いてください。
*   **Rationale**: 多くのデータベースAPI（特にPostgREST等のHTTPラッパー）は、権限不足による書き込み失敗をエラーとして報告しません。`error: null` のみを検証する実装は、「成功したように見えるがデータが永続化されていない」という最も診断困難な「Phantom Success」を引き起こします。

### 13.39. The Post-Mutation Verification Fetch（ミューテーション後即時検証フェッチ）
*   **Law**: 特に重要度の高いミューテーション（画像の並び替え、ステータス変更、権限変更等）において、書き込み操作の直後に**同一レコードを再取得（SELECT）**し、意図した値がデータベースに永続化されたことをログまたはアサーションで確認することを推奨します。
*   **Action**:
    1.  **Verification Fetch**: `update()` の直後に同じIDで `select()` を実行し、現在値をログ出力してください。これにより、問題が「DBへの書き込み失敗」なのか「アプリでの読み込み・キャッシュ問題」なのかを100%確実に切り分けることができます。
    2.  **Diagnostic Isolation**: リロード後にデータが元に戻る現象が報告された場合、まずこのパターンでサーバーサイドの物理的な値を確認し、問題の層（DB / Cache / UI）を特定してください。
    3.  **Production Guard**: 本番環境では、パフォーマンスへの影響を考慮し、この検証をフラグ（`DEBUG_MUTATIONS=true`）で有効化するか、ログレベルで制御してください。
*   **Rationale**: キャッシュの不整合（フレームワークのData Cache / Router Cache等）やトリガーによる値の上書き等、書き込み操作そのものは成功してもデータが反映されないケースは多々あります。即時検証フェッチは、サイレントな永続化失敗を迅速に特定するための最も確実なデバッグ手法です。

### 13.40. The Read-Write Privilege Symmetry（読み書き権限の対称性義務）
*   **Law**: データの書き込み（Mutation）に特権クライアント（管理者権限等）を使用している場合、**「編集のための読み込み」にも同等の可視性を保証**しなければなりません。書き込み権限と読み込み権限の不一致は「片肺状態」を引き起こします。
*   **Action**:
    1.  **Read-Write Parity**: 管理画面等において、書き込みが特権クライアント（RLSバイパス等）で行われている場合、編集フォームへのデータ取得も同等の権限レベルで行ってください。権限不一致は、「保存は成功するがリロードすると元に戻る」という極めて不透明なバグを引き起こします。
    2.  **Spec Synchronization**: データ取得に使用するプロジェクション（Select Spec / カラム指定）が、書き込み対象の全カラムを包含しているか検証してください。取得Specにカラムが不足していると、保存はされるが表示されない項目が生じます。
    3.  **Gateway Awareness**: 管理目的のデータ取得関数は、その用途を関数名で明示的に示し（例: `getAdminItemById`）、適切な権限レベルのクライアントを使用してください。
*   **Rationale**: 書き込みと読み込みで異なる権限レベルを使用することは、セキュリティの「穴」ではなくても、データの「不可視化」を引き起こします。特にRLSを使用する環境では、SELECTポリシーが不完全な場合、DBに存在するデータが取得時にフィルタリングされ、UIには表示されないという診断困難なバグが発生します。

### 13.41. The Sub-Step Mutation Integrity Protocol（マルチステップ書き込み整合性）
*   **Law**: 単一のサービスメソッドまたはトランザクション内で**複数の非同期書き込み操作**（複数テーブルへの INSERT/UPDATE、外部APIへの連続呼び出し等）を行う場合、**各ステップの結果を個別に検証**しなければなりません。
*   **Action**:
    1.  **Per-Step Error Check**: 各書き込み操作の直後に `error` / `count` / `status` を検証してください。最初のステップが成功したことを前提に後続ステップを実行し、途中のエラーを握りつぶすことは「Partial Phantom Success（部分的幽霊成功）」の直接的な原因です。
    2.  **Fail-Fast Cascade**: いずれかのステップでエラーが検出された場合、後続のステップを実行せず即座にエラーを返却してください。部分的に更新された状態を放置することは、データ不整合の温床です。
    3.  **Composite Error Reporting**: 複数ステップの結果を集約し、どのステップで失敗したかを呼び出し元に明確に伝達するエラーレスポンスを構築してください（例: `{ step: 'update_metadata', error: '...' }`）。
    4.  **Diagnostic Logging**: 各ステップの実行結果（成功行数、影響カラム等）をログに出力し、障害発生時の原因特定を迅速化してください。
*   **Rationale**: マルチステップの書き込み処理において、中間ステップのエラーを無視すると「メインデータは更新されたが関連データは古いまま」という不整合が発生します。この種の部分的成功は、ユーザーには「保存成功」と表示されるため発見が極めて困難です。

### 13.42. The Structured Error Logging Mandate（構造化エラーログ義務）
*   **Law**: エラーオブジェクトをログに出力する際、**文字列テンプレートへの直接埋め込み**（例: `` `Error: ${error}` ``）を禁止します。エラーオブジェクトは必ず**構造化された形式**でログに記録しなければなりません。
*   **Action**:
    1.  **No Template Embedding**: `` `Error occurred: ${error}` `` のパターンは `[object Object]` を出力し、根本原因の情報を完全に喪失させます。
    2.  **Destructured Logging**: エラーオブジェクトの `message`, `code`, `details`, `hint` 等のプロパティを明示的に分解してログに出力してください（例: `Logger.error('Operation failed', { message: error.message, code: error.code, details: error.details })`）。
    3.  **JSON Serialization**: 構造化ログシステムを使用する場合は、`JSON.stringify(error, null, 2)` 等でエラーオブジェクト全体をシリアライズし、全プロパティを保存してください。
    4.  **Stack Trace Preservation**: `Error` インスタンスの `stack` プロパティは、テンプレートリテラルに含めると消失します。常に第2引数またはメタデータオブジェクトとして渡してください。
*   **Rationale**: `[object Object]` としてログに記録されたエラーは、根本原因の特定を事実上不可能にします。特にRLS違反、認証エラー、型不一致等の微妙なエラーは `code` や `details` に重要な診断情報を含んでおり、テンプレート埋め込みはこれらを全て喪失させます。

### 13.43. The Type Integrity Prohibition Protocol（型詐称の禁止）
*   **Law**: `as any` や `as never` を用いて型エラーを黙殺する行為は「バグの埋め込み」と定義します。型を正しく合致させることが**唯一の正当な解決策**であり、キャストによる回避は全面禁止です。
*   **Action**:
    1.  **Zero `as any` Policy**: コードベース全体で `as any` の使用を原則禁止します。ESLint ルール `@typescript-eslint/no-explicit-any` を `error` に設定し、CIで物理的にブロックしてください。
    2.  **Root Cause Resolution**: 型エラーが発生した場合は、キャストではなく「型定義の修正」「DTOの再設計」「ジェネリクスの適用」のいずれかで**根本原因**を解消してください。
    3.  **Exceptional Cast Documentation**: やむを得ず型アサーションが必要な場合（外部ライブラリの型定義不備等）は、`// SAFETY: <理由>` コメントを必ず付記し、コードレビューで承認を得てください。
    4.  **Lint Suppression Audit**: `// eslint-disable` や `// @ts-ignore` の使用は「技術的負債の宣言」です。使用時は必ず対応するIssue番号を併記し、四半期ごとに棚卸しを義務付けます。
*   **Rationale**: `as any` は型安全性を完全に無効化し、本来コンパイル時に検出されるべきバグを実行時に先送りします。特にDTO変換やAPI境界での使用は、データ不整合を隠蔽し、障害発生時の原因特定を著しく困難にします。

### 13.44. The Thin Controller Mandate（薄いコントローラー原則）
*   **Law**: API Route / Controller / Route Handler は、リクエストのパース・バリデーションと権限チェックのみを担当する「薄い層」として設計しなければなりません。ビジネスロジックはService層に委譲し、Controllerに直接記述することを禁止します。
*   **Action**:
    1.  **Controller Responsibilities**: Controller内のコードは以下に限定します: (a) リクエストボディ/パラメータのパースとバリデーション、(b) 認証/認可チェック、(c) Service層の呼び出し、(d) レスポンスの構築と返却。
    2.  **No DB Access in Controllers**: Controller / Route Handler 内での直接的なDB呼び出し（ORMクエリ、SQL実行等）を禁止します。全てのデータアクセスはService/Gateway層を経由してください。
    3.  **Testability**: Service層はControllerから独立してユニットテスト可能でなければなりません。Controllerに密結合したロジックはテスタビリティを破壊します。
    4.  **Error Translation**: Service層から発生した例外は、Controller層でHTTPステータスコードとエラーレスポンス形式に変換してください。Service層がHTTPステータスコードを知っていてはなりません。
*   **Rationale**: 肥大化したControllerはテスト困難、再利用不能、変更影響の把握不能という三重苦を生みます。薄いController + 厚いServiceの分離は、保守性とスケーラビリティの基盤です。

### 13.45. The DTO Boundary Casting Protocol（DTO境界キャスト規約）
*   **Law**: データベースやORMからの戻り値（緩い型）を厳格なDTO型に変換する際、`as any` によるキャストを禁止します。安全な型変換戦略を義務付けます。
*   **Action**:
    1.  **No `as any` Bridge**: `dbResult as any as MyDTO` のようなダブルキャストは、型安全性の完全な放棄です。禁止します。
    2.  **Explicit Mapping**: DB結果からDTOへの変換は、明示的なマッピング関数（`toDTO(dbResult): MyDTO`）を作成し、各フィールドを個別にマップしてください。
    3.  **Validated Cast**: やむを得ず型アサーションが必要な場合は、`as unknown as TargetType` による意図的な二段階変換を使用し、変換意図を明示してください。ただし、Zodなどのランタイムバリデーションとの併用を強く推奨します。
    4.  **Generated Types**: DB型定義は自動生成（Prisma, Drizzle, Supabase CLI等）を使用し、手書きの型定義との乖離を物理的に防止してください。
*   **Rationale**: DB層とアプリケーション層の型境界は、最もデータ不整合が発生しやすい箇所です。`as any` によるキャストは、カラム追加・名変更時のサイレントなデータ消失を引き起こし、ビルドは通るがデータが壊れる最悪のバグを生み出します。

### 13.46. The CQRS Separation Mandate（コマンドクエリ責務分離義務）
*   **Law**: Read操作（参照）とWrite操作（更新）のロジックを同一の関数・クラスに混在させることを禁止します。Query（Read専用）とCommand（Write専用）を明確に分離してください。
*   **Action**:
    1.  **Query/Command Split**: データアクセス層は、読み取り専用の `QueryGateway`（または `ReadService`）と、書き込み専用の `CommandGateway`（または `WriteService`）に分離してください。
    2.  **No Side Effects in Queries**: Query系のメソッドは、データの読み取りと変換のみを行い、DBへの書き込みや外部APIの呼び出し等の副作用を一切持ってはなりません。
    3.  **Independent Scaling**: Read/Writeの分離により、読み取り負荷が高い場合はRead Replicaの追加、書き込みが集中する場合はWrite最適化と、独立したスケーリング判断が可能になります。
    4.  **Naming Convention**: メソッド名でRead/Writeの意図を明示してください（例: `getUser` / `findUsers` は Read、`createUser` / `updateUser` は Write）。
*   **Rationale**: Read/Writeの混在は、キャッシュ戦略の適用を困難にし、パフォーマンスボトルネックの特定を遅延させます。CQRS分離は、コードの可読性向上、テスタビリティの改善、そして将来のイベントソーシングやマイクロサービス化への移行パスを確保します。

### 13.47. The Cache Strategy Layer Protocol（階層化キャッシュ戦略義務）
*   **Law**: データ特性を無視した一律のキャッシュ戦略（全件TTL固定 / キャッシュ完全無効化）を禁止します。データの変更頻度と鮮度要件に基づいた**階層化キャッシュ戦略**を定義してください。
*   **Action**:
    1.  **Data Classification**: アプリケーションで扱うデータを以下のティアに分類してください:
        - **STATIC** (変更なし): 法的文書、利用規約等。CDN/ISR（リビルドトリガー式）。
        - **WARM** (日次〜週次変更): マスターデータ、カテゴリ等。TTL 5分〜1時間 + SWR (Stale-While-Revalidate)。
        - **HOT** (分単位変更): ユーザー投稿コンテンツ、商品在庫等。短TTL (30秒〜5分) + オンデマンドリバリデーション。
        - **REALTIME** (即時反映): チャット、通知、決済ステータス等。キャッシュ無効 + WebSocket/SSE。
    2.  **No Blind Cache**: `cache: 'force-cache'` や `revalidate: 0` を「とりあえず」で設定することを禁止します。各データソースに対してティア分類に基づいた明示的なキャッシュ戦略を文書化してください。
    3.  **Cache Invalidation Strategy**: 書き込み時のキャッシュ無効化戦略（`revalidateTag` / `revalidatePath` / Purge API等）を、データ更新フローと一体で設計してください。
    4.  **Monitoring**: キャッシュヒット率を計測し、90%未満のエンドポイントは最適化対象としてください。
*   **Rationale**: 一律のキャッシュ戦略は、静的データに不要なリクエストを送り（コスト増加）、リアルタイムデータに古い情報を返す（UX劣化）という両面で損害を与えます。データ特性に基づく階層化は、コスト効率とユーザー体験の両立を実現する唯一の設計パターンです。

### 13.48. The Explicit Mapping Mandate（ミューテーション明示マッピング義務）
*   **Law**: Service層やServer Action内でデータベースへの書き込みペイロードを構築する際、スプレッド構文（`...input`）による一括展開を**禁止**します。全てのフィールドを明示的にマッピングしてください。
*   **Action**:
    1.  **No Spread Payload**: `supabase.from('table').update({ ...formData })` のようなスプレッド展開によるペイロード構築を禁止します。入力オブジェクトに含まれる予期しないフィールド（UIが追加した状態管理用フィールド等）がDBに送信され、エラーまたはデータ汚染を引き起こします。
    2.  **Field-by-Field Construction**: ペイロードは `{ name: input.name, email: input.email, status: input.status }` のように、各フィールドを個別に指定してください。これにより、送信されるデータの範囲が明確になり、レビューが容易になります。
    3.  **JSONB Structural Mapping**: ネストされたJSON/JSONB構造を持つフィールドも、トップレベルのスプレッドに頼らず、内部構造を明示的に構築してください。特に配列データ（画像リスト等）は、元データの順序と内容を正確に維持するマッピングが必要です。
    4.  **DTO-Payload Alignment Check**: DTOにフィールドが追加された際は、Service層のマッピングにも同時に追加してください。マッピングの欠落は「保存しても反映されない」サイレントバグの最も一般的な原因です。
*   **Rationale**: スプレッド構文は簡潔ですが、「何が送信されるか」の制御を放棄する行為です。特に管理画面のような大規模フォームでは、UIの状態管理用フィールド、計算フィールド、未定義フィールドが混入するリスクが高く、明示的なマッピングだけがデータの整合性を保証します。

### 13.49. The Mutation Count Verification Protocol（ミューテーション影響行数検証義務）
*   **Law**: データベースへの書き込み操作（INSERT/UPDATE/DELETE）の結果を検証する際、`error` の有無だけでなく、**影響を受けた行数（`count`）**を必ず確認しなければなりません。`error: null` かつ `count: 0` の組み合わせは「Phantom Success（偽の成功）」であり、実質的な失敗として扱ってください。
*   **Action**:
    1.  **Count Validation**: ID指定の単一レコード操作（`.eq('id', id)`）では、`count` が `1`（または期待される数）であることを検証してください。`count` が `0` または `null` の場合は、権限不足（RLS拒否）またはレコード不在として例外をスローしてください。
    2.  **Bulk Operation Awareness**: 一括更新・削除操作では、`count` が入力データの件数と一致することを検証してください。部分的な成功（10件中7件のみ更新）はデータの不整合を意味します。
    3.  **Sub-Step Integrity**: 単一のService関数内で複数のテーブルを連続して更新する場合、全てのサブステップで `error` と `count` の両方を検証してください。途中のステップの失敗をスキップすると、一部だけが更新された「Partial Phantom Success」となります。
    4.  **Diagnostic Logging**: ミューテーション結果のログには `count` を必ず含めてください（例: `Logger.info('Update result:', { count })`）。事後の障害分析において、影響行数は最も重要な手がかりです。
*   **Rationale**: Row Level Security（RLS）を使用するデータベースでは、権限不足のクエリが「エラーなし・0行影響」という形でサイレントに拒否されることがあります。`error` のみをチェックする従来のパターンでは、この「成功のように見える失敗」を検知できず、ユーザーには「保存したのに反映されない」という最も不透明なバグとして現れます。

### 13.50. The Authentication Guard Enumeration Consistency（認証ガード列挙整合性義務）
*   **Law**: ロールベースアクセス制御（RBAC）において、許可ロールのリストを複数のガード関数で個別管理することを**禁止**します。全てのガード関数は、共通の定数配列（例: `ALLOWED_ADMIN_ROLES`）を参照し、ロール定義の単一真実源（SSOT）を確立しなければなりません。
*   **Action**:
    1.  **Shared Role Constants**: 許可ロール（`admin`, `super_admin`, `master_admin` 等）は、単一の定数配列として定義し、全てのガード関数（ページアクセス制御、Server Action認可、RLSポリシー等）がこの定数を参照してください。
    2.  **Simultaneous Update Mandate**: 新しいロールを追加する際は、全てのガード関数が自動的に更新される構造にしてください。定数配列を共有していれば、更新箇所は1箇所で済みます。
    3.  **Dead Zone Detection**: 「画面には入れるが、操作（保存等）だけが失敗する」という不透明なデッドロックを防ぐため、ページレベルのガードとアクションレベルのガードが同一のロール集合を参照していることを定期的に監査してください。
    4.  **Failure Transparency**: ガード関数が認可エラーを返す際は、フロントエンドでエラーをキャッチし、開発環境では `Logger.warn` でロール不整合を即座に検知できるようにしてください。
*   **Rationale**: ロールの種類が増えた際に、全てのガード関数を同時に更新し忘れると、「管理画面にはログインできるが、特定の操作だけがサイレントに拒否される」という極めて不透明なデッドロックが発生します。この種のバグはエラーメッセージも表示されないため、原因特定に膨大な時間を浪費します。

### 13.51. The Sub-Step Mutation Integrity Protocol（サブステップ・ミューテーション整合性義務）
*   **Law**: 単一のサービスメソッド内で複数の非同期書き込み操作（INSERT/UPDATE/DELETE）を連続して実行する場合、**全てのサブステップで `error` オブジェクトを検証**し、エラーが発生した場合は即座にプロセスを停止して例外をスローしなければなりません。
*   **Action**:
    1.  **No Silent Continue**: `await supabase.from('table').delete()` のように戻り値の `error` をチェックせず後続処理に進むことを禁止します。全ての書き込み操作で `const { error } = await ...` として結果を受け取り、エラーチェックを行ってください。
    2.  **Step-by-Step Logging**: 各サブステップの開始時と完了時にログを出力し（例: `Logger.info('[Step 2/5] Updating tags...')`）、障害発生時にどのステップで失敗したかを即座に特定できるようにしてください。
    3.  **Aggregate Error Reporting**: 中間ステップの失敗が最終結果（`return { success: true }`）を汚染しないよう、サービスメソッド全体を `try-catch` で囲み、いずれかのステップで例外が発生した場合は明示的な失敗レスポンスを返してください。
    4.  **Transaction Awareness**: 外部APIのシンプルな呼び出し（PostgREST等）はデフォルトでアトミックなトランザクションとして扱われないことを認識し、途中失敗時の補償処理（ロールバック相当）や冪等性の確保を設計に組み込んでください。
*   **Rationale**: マルチテーブル更新において途中のステップの失敗を無視すると、メインテーブルは更新されたが関連テーブルは古いままという「Partial Phantom Success（部分的偽成功）」が発生します。ユーザーには「保存成功」と表示されるにもかかわらず、一部のデータだけが反映されないため、問題の発見が大幅に遅れます。

### 13.52. The Error Object Transparency Mandate（エラーオブジェクト透過性義務）
*   **Law**: エラーハンドリングにおいて、エラーオブジェクトをそのまま文字列として連結・出力すること（結果として `[object Object]` が出力される）を**禁止**します。エラーの `message`, `code`, `details` 等のプロパティを**明示的に分解**してログに記録しなければなりません。
*   **Action**:
    1.  **Structured Error Logging**: `Logger.error('Operation failed', { error: err.message, code: err.code, details: err.details })` のように、エラーオブジェクトのプロパティを個別のフィールドとして出力してください。`Logger.error('Failed: ' + error)` は `[object Object]` となり、原因特定が不可能です。
    2.  **Catch Block Standard**: 全ての `catch` ブロックにおいて、捕捉したエラーが `Error` インスタンスか `PostgrestError` か等を判定し、それぞれのプロパティを適切に抽出してください。
    3.  **Error Serialization**: クライアントへ返すエラーレスポンスにおいても、内部エラーの構造を適切に変換し、`{ success: false, error: 'Human-readable message', code: 'ERROR_CODE' }` 形式で返却してください。
    4.  **Development vs. Production**: 開発環境ではエラーの全プロパティをログに含め、本番環境では機密情報（スタックトレース、内部パス等）をマスクした上で、運用に必要な情報（`code`, `message`）のみを出力してください。
*   **Rationale**: `[object Object]` は、障害対応における最も無価値な情報です。特にデータベースエラー（Supabase `PostgrestError` 等）は `message`, `code`, `details`, `hint` といった豊富な診断情報を持っていますが、オブジェクトの直接連結によりこれらが全て失われ、障害の根本原因分析が事実上不可能になります。

### 13.53. The Post-Mutation Verification Fetch Protocol（ミューテーション後検証フェッチ義務）
*   **Law**: 重要度の高い書き込み操作（画像の並び替え、ステータス変更、権限変更等）の直後に、**同一IDで即時 `select`（再取得）を実行**し、データが実際にデータベースへ永続化されたことをログで検証しなければなりません。
*   **Action**:
    1.  **Verification Fetch Pattern**: ミューテーション（`update`, `insert`, `delete`）の直後に、同一レコードを `select` で取得し、更新後の値をログに出力してください（例: `Logger.info('[Verify] Post-update:', { id, updatedAt: result?.updated_at })`）。これにより、問題が「DB書き込みの失敗（RLS/Trigger）」なのか「アプリケーション側の読み込み/表示の失敗（Cache/UI）」なのかを100%確実に切り分けることができます。
    2.  **Diagnostic Isolation**: 検証フェッチの結果が更新後の値を返すにもかかわらずUIに反映されない場合、問題はキャッシュ（Data Cache / Router Cache）またはフォームの再初期化にあると確定できます。逆にフェッチ結果が古い値を返す場合、問題はDB層（RLS拒否、トリガーによる上書き等）にあると確定できます。
    3.  **Conditional Application**: 全てのミューテーションに適用する必要はありません。以下のケースで重点的に使用してください: (a) RLSが関与する特権操作、(b) 複数テーブルの連続更新、(c) ユーザーから「保存しても反映されない」と報告された箇所、(d) JSONB型の複雑なデータ構造の更新。
    4.  **Production Consideration**: 本番環境では検証フェッチのログレベルを `debug` に下げるか、フィーチャーフラグで無効化できるようにしてください。ただし、デバッグ時に即座に有効化できる仕組みは維持してください。
*   **Rationale**: 「保存したのに反映されない」はWebアプリケーションにおいて最も診断困難なバグの一つです。原因がDB書き込みの失敗（RLS、トリガー、権限不足）なのか、キャッシュの不整合なのか、フォーム再初期化の問題なのかを区別するには、ミューテーション直後のDB内の物理的な値を確認するしかありません。検証フェッチはこの切り分けを即座に行える唯一の確実な手段です。

### 13.54. The Static Master Protocol（定数ファイル一元管理義務）
*   **Law**: アプリケーション全体で使用される定数値（メニュー項目、カテゴリ定義、ステータスラベル、選択肢リスト等）は、必ず**専用の定数ファイル（例: `constants/`, `config/`）に一元定義**し、コンポーネントやページファイル内でのハードコードを禁止します。
*   **Action**:
    1.  **Single Source of Truth**: 各ドメインの定数は `constants/<domain>.ts` 等の専用ファイルにまとめ、`as const` でイミュータブルに定義してください。コンポーネント内でリテラル配列やオブジェクトを直接定義することを禁止します。
    2.  **Type Derivation**: 定数定義から `typeof` + インデックスアクセス型で型を自動導出してください（例: `type Status = typeof STATUSES[number]`）。定数と型を別々に管理すると同期漏れの原因になります。
    3.  **Change Impact Control**: 定数の変更が影響する全箇所を即座に把握できるよう、定数はエクスポートして参照で使用してください。マジックストリングの散在は、変更漏れによるサイレントバグの最大原因です。
    4.  **i18n Readiness**: 表示ラベルを定数として定義する場合は、i18nキーとの対応関係を明確にし、将来の多言語対応時に定数ファイルの変更だけで済む構造にしてください。
*   **Rationale**: 定数がコンポーネント間に散在すると、ビジネスルールの変更時に全ファイルを検索・修正する必要が生じ、変更漏れによるUI不整合やロジックバグが頻発します。一元管理はSSOT原則の基本であり、リファクタリングコストを劇的に削減します。

### 13.55. The Generic Type Inference Safety Protocol（ジェネリック型推論安全性）
*   **Law**: 汎用コンポーネント、ユーティリティ関数、共有型定義において、`Record<string, any>` や `{ [key: string]: any }` 等の**anyインデックスシグネチャ**を「便利な型」として使用することを**禁止**します。具体的な型パラメータ、`unknown`、または制約付きジェネリクスを義務付けます。
*   **Action**:
    1.  **No Any Index**: `Record<string, any>` の代わりに `Record<string, unknown>` を使用し、アクセス時に型ガードで絞り込んでください。`any` は型チェックを完全に無効化し、プロパティ名のタイポすら検出不可能にします。
    2.  **Constrained Generics**: 汎用関数には `<T extends BaseType>` のように制約付きジェネリクスを使用し、呼び出し元に型安全性を保証してください。`<T>` だけでは `T` が `any` に推論されるリスクがあります。
    3.  **Mapped Type Preference**: 動的なキーが必要な場合は、`Record` よりも `Pick<FullType, K>` や `Partial<FullType>` 等のMapped Typeを優先してください。これにより、許可されたキーの範囲がコンパイル時に検証されます。
    4.  **Inference Verification**: ジェネリック関数の呼び出し箇所で、TypeScriptのホバー表示により推論結果が期待通りか確認してください。`any` に推論されている場合は、型パラメータの制約を見直してください。
*   **Rationale**: `any` インデックスシグネチャは型安全性を根底から破壊し、存在しないプロパティへのアクセス、誤った型の代入、構造不整合のすべてをコンパイル時に検出不可能にします。これは「型のある `any`」であり、TypeScriptを使用する意義そのものを無効化する最も危険なアンチパターンの一つです。

### 13.56. The Multi-Axis Deployment Audit Protocol（多軸デプロイ監査義務）
*   **Law**: 機能追加・変更時、「動く」だけではデプロイ基準を満たしません。以下の**4軸すべてでグリーン**であることを自律的に検証してからデプロイ可能とします。
*   **Action**:
    1.  **Security (監査ログ)**: 破壊的アクション（作成・更新・削除）に監査ログ（`recordAuditLog` 等）が計装されているかを確認してください。証跡のない操作はガバナンス不能であり、セキュリティ事故発生時の追跡を不可能にします。
    2.  **Structured Data (構造化データ)**: 公開ページの変更時、構造化データ（JSON-LD, OpenGraph等）が最新の状態に更新されているかを確認してください。SEOとAIエージェントの正確な情報取得に直結します。
    3.  **UX (ユーザー体験)**: エラーメッセージ、ツールチップ、確認ダイアログがユーザーの言語で適切に提供されているかを確認してください。技術メッセージの露出はプロダクション品質を毀損します。
    4.  **Type Safety (型安全性)**: `any`、不透明なキャスト（`as unknown as`）、anyインデックスシグネチャが新たに導入されていないかを確認してください。
*   **Rationale**: 「動いたら完了」という意識は、セキュリティ、SEO、UX、保守性のいずれかに盲点を残します。多軸の品質基準を構造的に要求することで、デプロイ後の手戻りとインシデントを予防します。

### 13.57. The DTO Segregation Protocol（型定義ファイル分割義務）
*   **Law**: 肥大化した単一の型定義ファイル（例: `types/index.ts`）にプロジェクト全体のDTO・インターフェースを集約することを**禁止**します。機能ドメイン単位でファイルを分割してください。
*   **Action**:
    1.  **Domain-Based Splitting**: DTO定義は機能ドメインごとに分割してください（例: `types/store.ts`, `types/user.ts`, `types/article.ts`）。1ファイルに10を超えるDTO定義が含まれる場合は、分割の検討を義務付けます。
    2.  **No Circular References**: 型定義ファイル間の循環参照（`A → B → A`）を防止してください。共通の基底型は `types/common.ts` 等の共有ファイルに配置し、依存の方向を一方向に保ちます。
    3.  **AI Context Efficiency**: AIエージェントが関連する型のみをピンポイントで読み取れる構造を維持してください。巨大な型ファイルはAIのコンテキストウィンドウを浪費し、精度を低下させます。
    4.  **Index Re-export**: 利便性のため `types/index.ts` からの再エクスポート（`export { StoreDTO } from './store'`）は許可しますが、そのファイル内で型定義を直接行うことは禁止します。
*   **Rationale**: 巨大な型定義ファイルは、開発者の認知負荷を増大させ、AIエージェントのコンテキスト効率を劣化させ、Git上でのマージコンフリクトを頻発させます。ドメイン単位の分割により、関心の分離と並行開発の効率化を実現します。

### 13.58. The Mapper Input Robustness Protocol（マッパー入力堅牢性）
*   **Law**: DTOマッパー関数（データベース行→DTO変換関数）の設計において、**Postelの法則**「出力は厳格に、入力は寛容に（Be conservative in what you send, be liberal in what you accept）」を適用します。
*   **Action**:
    1.  **Liberal Input**: マッパー関数の入力型は、ORM/DBクライアントの推論結果が不完全（Partial、null混在、結合結果の不定形等）であることを前提とし、過度に厳密な型を強制しないでください。`Record<string, unknown>` やロスのない中間型の使用を許容します。
    2.  **Conservative Output**: マッパー関数の戻り値は、必ず明示的に定義されたDTO型（`StoreDTO`, `UserDTO` 等）であり、型チェッカーが全フィールドの存在と型を保証する状態にしてください。
    3.  **Internal Validation**: 入力の型を緩める代わりに、マッパー関数内部での値検証・Fallback処理（`input.name ?? ''`, `Number(input.price) || 0` 等）を徹底してください。これにより、不正な入力が安全なデフォルト値に変換されます。
    4.  **No Partial Cascade**: マッパー関数の入力型にPartialを使用したことにより、出力DTOのフィールドまでoptionalになる「Partial伝播」を防止してください。出力型は常に完全型（Required）です。
*   **Rationale**: ORM/DBクライアントの型推論は、テーブル結合やRPC呼び出し時に不完全な型を返すことが頻繁にあります。入力に厳密な型を強制すると、Partial不整合や`never`型エラーが頻発し、開発者は`as any`キャストに逃げる悪循環に陥ります。入力を寛容に、出力を厳格にすることで、実用性と型安全性を両立します。

### 13.59. The Migration Static Analysis Guard Protocol（マイグレーション静的解析防衛）
*   **Law**: データベースマイグレーションファイルのPush/Merge時に、CIパイプラインおよびPre-pushフック（Git Hook）で**静的解析**を実行し、危険なSQLパターンを物理的に拒否する仕組みを義務付けます。人間の注意に依存する「運用ルール」は必ず破られます。システム自らが拒否する自動ガードのみが本番環境を守ります。
*   **Action**:
    1.  **Forbidden Pattern Detection**: 以下のパターンをマイグレーションファイルから検出した場合、Push/Mergeを拒否してください。
        -   **`UPDATE` without `DO` block**: WHERE句なし、または競合ハンドリングなしの無防備な更新。データ不整合（Constraint Violation）を招きます。
        -   **`INSERT` without `ON CONFLICT`**: 一意制約違反を招く無防備な追加。
        -   **`UNIQUE` constraint without Cleanup**: 既存の重複データを掃除せずに一意制約を追加すると、マイグレーション適用時にエラーで停止します。
    2.  **Pre-push Hook**: ローカル環境でのPush前にスクリプト（例: `scripts/migration-guard.ts`）を実行し、危険なSQLを即座にフィードバックしてください。`--no-verify` でのフック回避は、プロジェクトの信頼性を破壊する行為として禁止します。
    3.  **CI Pipeline**: GitHub Actions等のCIにおいて `migration:check` ジョブを常時稼働させ、ヒューマンエラーの最終防衛線としてください。このCIジョブの削除・無効化は禁止します。
    4.  **Custom Rules**: プロジェクト固有の危険パターン（例: `DROP TABLE` without `IF EXISTS`、`ALTER TABLE DROP COLUMN` without backup）もルールセットに追加可能な拡張設計としてください。
*   **Rationale**: マイグレーションの事故は「本番データの不可逆的破壊」に直結します。コードレビューのみに依存した防衛は、レビュアーの見落としや緊急デプロイ時のスキップにより容易に突破されます。機械的な静的解析ガードは、24時間365日、一切の例外なく本番環境を守り続けます。

### 13.60. The Feature Flag Lifecycle Protocol（フィーチャーフラグ運用規律）
*   **Context**: Feature Flagは安全なリリースを可能にしますが、管理されないフラグはコードの複雑性を増大させ、技術的負債となります。フラグの作成から削除までのライフサイクルを厳格に管理してください。
*   **Lifecycle**:
    | フェーズ | 説明 |
    |:--------|:-----|
    | **作成** | フラグ名・目的・期限をドキュメント化 |
    | **有効化** | ステージング環境で検証後、本番に段階展開 |
    | **全展開** | 全ユーザーに展開完了、フラグ削除のカウントダウン開始 |
    | **削除** | フラグ関連コードを全て削除し、クリーンな状態に戻す |
*   **最大存続期間**: **90日**。超過したフラグは技術的負債として記録し、次スプリントで削除を優先してください。
*   **命名規約**: `FF_<FEATURE_NAME>` 形式を推奨します。
*   **Prohibition**: Feature Flagのネスト（入れ子）は認知的複雑性を爆発させるため**禁止**します。
*   **Cleanup Obligation**: フラグを削除した際は、関連する条件分岐コード（`if (featureFlags.ff_xxx)`）も**同一PRで**削除しなければなりません。放置は技術的負債の蓄積とみなします。
*   **四半期棚卸し義務**: 四半期末にフラグ一覧を棚卸しし、以下のルールを適用してください。
    | 状態 | 日数 | 対応 |
    |:-----|:-----|:-----|
    | ON（全ユーザー展開済み） | > 30日 | フラグを削除し、新機能コードのみ残す |
    | OFF（廃止決定） | > 30日 | フラグとレガシーコードの両方を削除 |
    | 実験中 | > 90日 | 技術的負債として記録、次スプリントで決着 |
*   **Rationale**: Feature Flagは「一時的なスイッチ」であり「永続的な設定」ではありません。放置されたフラグはコードパスを指数関数的に増加させ、テスト困難性を高め、予期しないバグの温床となります。定期的な棚卸しとライフサイクル管理により、コードベースの健全性を維持します。
