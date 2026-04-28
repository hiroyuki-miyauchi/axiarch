# 30. エンジニアリング基準 (Engineering Standards - General)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-04-20（Rev.8）

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「コードは資産ではなく負債 — すべての行はその存在意義を証明しなければならない。」
> すべてのエンジニアリング判断はスピードよりも正確性・セキュリティ・保守性を優先しなければならない。
> **セキュリティ > 正確性 > 保守性 > パフォーマンス > 開発速度** の優先順位を厳守せよ。
> この文書はエンジニアリング品質と標準に関するすべての設計判断の最上位基準である。
> **22パート・160セクション構成。**

---

## 目次

| Part | トピック | セクション | セクション数 |
|------|---------|-----------|:--:|
| I | コード品質とクリーンコード | §1.0 – §1.9 | 10 |
| II | インフラとパフォーマンス | §2.0 – §2.5 | 6 |
| III | 設計によるセキュリティ (DevSecOps) | §3.0 – §3.9 | 10 |
| IV | 技術的負債とクリーンアップ | §4.0 – §4.4 | 5 |
| V | AIファースト開発 | §5.0 – §5.4 | 5 |
| VI | グリーンコーディングとサステナビリティ | §6.0 – §6.3 | 4 |
| VII | ゼロバグ・ポリシー | §7.0 – §7.3 | 4 |
| VIII | 継続的学習と検証 | §8.0 – §8.2 | 3 |
| IX | 互換性とテスト | §9.0 – §9.5 | 6 |
| X | Gitとバージョン管理 | §10.0 – §10.6 | 7 |
| XI | ドキュメント運用 | §11.0 – §11.2 | 3 |
| XII | エンジニアリング品質プロトコル | §12.1 – §12.12 | 12 |
| XIII | 高度アーキテクチャ原則 | §13.1 – §13.15 | 15 |
| XIV | プラットフォームエンジニアリング | §14.1 – §14.6 | 6 |
| XV | レジリエンスエンジニアリング | §15.1 – §15.5 | 5 |
| XVI | 開発者体験ガバナンス (DX) | §16.1 – §16.4 | 4 |
| XVII | ゼロダウンタイム・スキーマ進化 | §17.1 – §17.5 | 5 |
| XVIII | アクセシビリティ・エンジニアリング | §18.1 – §18.7 | 7 |
| XIX | 先進エンジニアリング実践 | §19.1 – §19.6 | 6 |
| XX | AIエージェント・オーケストレーション安全基準 | §20.1 – §20.5 | 5 |
| XXI | **プライバシー・エンジニアリング** | **§21.1 – §21.7** | **7** |
| XXII | **ランタイム・セキュリティ強化** | **§22.1 – §22.8** | **8** |
| | | **合計** | **147** |

---

## Part I: コード品質とクリーンコード (Code Quality & Clean Code)

### 1.0. 命名規約と構造原則 (Naming & Structural Foundations)
*   **The Consolidated Naming Convention**:
    *   **Files & Directories**: 全てのファイル名とディレクトリ名は `kebab-case` (例: `user-profile-card.tsx`) で統一します。PascalCaseやsnake_caseはOS間のGit互換性問題（Case Sensitivity）を引き起こすため厳禁です。
    *   **Components**: ファイル名は `kebab-case` ですが、コンポーネント名は `PascalCase`、関数名は `camelCase` とします。
    *   **The Barrel File Ban**: `index.ts` による再エクスポート（Barrel File）は、循環参照とTree Shaking阻害の主因となるため、原則禁止とします。
*   **UI/Logic Consistency (完全統一)**:
    *   **原則**: 「似ているが違う」はプロ意識の欠如であり、バグです。すべての機能（削除、編集、一覧）において、UIとロジックは統合されていなければなりません。
    *   **Tiered Security**: セキュリティはリスクに応じて段階化します。
        *   **Tier 1**: 一般的な単体操作は「確認のみ」とします。
        *   **Tier 2**: 一括操作、および**ユーザー削除などの最重要単体操作**は「高セキュリティ認証（OTP/Passkey/2FA等）必須」とします。
*   **The Hierarchical Data Principle (1:N Core)**:
    *   **Law**: 複雑なドメインを設計する際は、必ずルートとなる親テーブルを定義し、関連データは $1:N$ の階層構造でぶら下げる「疎結合な親子関係」を貫いてください。単一の巨大なテーブルへの押し込み（God Table）は、マイグレーションとRLS設計の破綻を招く敗北行為です。
*   **The Tiered Service Mandate (Subscription Gating)**:
    *   **Law**: サービスレベル（Free/Paid）による制限は、必ず**サーバーサイド (Server Guards)** で強制してください。フロントエンドの表示制御のみに頼ることは禁止します。
    *   **Upsell Trigger**: 制限超過時には、上位プランへの動線を伴う明確なメッセージを返却してください。
*   **The Interoperable Ecosystem Mandate**:
    *   **Law**: アプリ内に保持される重要なドメインデータを、システムの外でも通用する「標準化された資産」として扱ってください。独自仕様に閉じ込めることは、将来のサービス連携とユーザーへの価値提供を阻害する敗北行為です。
    *   **Portable Design**: 可能な限り業界標準のスキーマ、定数、国際規格に準拠し、データそれ自体が「信頼性の高い証明書」として他システムへのポータビリティを持つように設計してください。

### 1.1. Omnichannel & Headless First Protocol
*   **Web is just ONE Client**:
    *   **Definition**: システム全体を設計する際、「Webサイト（Next.js）」は多数あるクライアントの**ほんの一つ**に過ぎないと定義します。
    *   **Vision**: 将来的なネイティブアプリ（iOS/Android）、外部メディア連携、IoT配信、AIエージェントとの対話を前提とします。
*   **API Mandate**: **全ての機能とデータ** は、再利用可能な API (Headless Architecture) を介して提供されなければなりません。
*   **Prohibition (The Web-Only Ban)**: Reactコンポーネント内へのビジネスロジックの閉塞や、HTML構造に依存したデータ設計は、**「最重要項目の違反」として厳禁** とします。

### 1.2. Realism First Protocol (Anti-Haribote)
*   **Definition**: UI（皮膚）が存在しても、その背後で「データの永続化」と「再取得（Hydration）」が完全に行われていない機能は、**「詐欺的実装（Deception）」** と定義し、実装完了とは認めません。
*   **Mandate (The Vein Check)**: 機能実装の完了条件は、**「UI → Action → DB → Action → UI」** というデータのRound-Tripが疎通していることを確認するまでコミットしてはなりません。
*   **Physical Verification**: 必ずDB（psql/Table Editor）で**物理的に値が書き込まれていること**を確認する義務を負います。
*   **Deception Penalty**: 保存されない設定画面や、リロードすると消える入力フォームをPRに含めることは、修正完了まで全ての作業を凍結します。

### 1.3. Structure First Protocol（構造化ファースト）
*   **Law**: 重要なビジネスデータ（資格、契約、健康状態、資産等）は、テキスト（非構造化データ）ではなく、可能な限りマスターデータ（M:N）やタグ形式で構造化して管理してください。
*   **Future-Proof Data Strategy (LTV & FinOps)**: データモデリング時は、将来的な FinOps や LTV 最大化に寄与する可能性のあるメタデータを、構造化された形で保持できるように設計してください。
*   **Autonomous Structure Strategy (Edge AI)**: 紙の証明書、領収書等の「非構造化物理アセット」は、OCR/Vision AI を活用して「高精度な構造化データ」へ自動変換するフローを標準実装として検討してください。
*   **Human-in-the-Loop Mandate**: AI（OCR/Vision等）によるデータ抽出結果は、常に **「下書き（Draft）」** として扱い、ユーザーが確認・修正した上で保存するフローを強制してください。AIによるDBへの直接書き込み（Auto-Save）は禁止します。
*   **PII Scrubbing**: AI処理対象に個人情報が含まれる場合、自動的に破棄またはマスキングしてください。第三者の個人情報は、本人の同意なく構造化データとして保持してはなりません。

### 1.4. Blueprint Compliance（設計書遵守）
*   **Entry Point**: すべての開発作業は、まず対応するルールファイルを確認することから始めます。
*   **Update First**: 実装中に設計変更が必要になった場合、**コードを書く前に（または同時に）Blueprintを更新**します。ドキュメントとコードの乖離は最大の技術的負債です。
*   **Code as Documentation**: Blueprintファイルはコードの一部です。実装を変更したら、必ず対応するルールファイルも更新し、乖離（Drift）を防いでください。
*   **The System Transparency Protocol (Stack Card)**: 使用している技術スタック（Framework, DB, UI Lib）のバージョン情報を、`PROMPT.md` または `tech_stack.md` に常に最新状態で維持してください。AIエージェントは「現在」の環境を知る由もありません。

### 1.5. Zero Warnings Mandate（警告ゼロ義務）
*   **ルール**: 警告（Warning）はエラー（Error）として扱います。CIは警告が1つでもあれば失敗させます。
*   **厳格なエラーハンドリング**: 空の `catch` ブロックは禁止です。全てのエラーはログに記録され、適切に処理されなければなりません。
*   **Zero Tolerance for Band-Aid Solutions**:
    *   **Prohibition**: `// @ts-ignore`, `any` キャスト、`legacy-peer-deps` は「思考停止」であり、エンジニアとしての敗北です。
    *   **Mandate**: 一時的な回避が必要な場合は、必ず `// TODO(#IssueID): reason` とチケット番号を添えて理由を記述してください。
*   **The Incident Response Protocol (SRE)**: セキュリティインシデント発生時の連絡網と初動対応を定義し、半年に1回訓練を行ってください。障害対応後は必ず根本原因を特定し、教訓をBlueprintへ反映させるまでを一つの不可分なプロセスとします。
*   **The Anti-Blindness Protocol (AI Hygiene)**: AIが生成したコードに含まれる `// ...` や `// implementation details` といった省略記法を、そのままファイルに保存することを物理的に禁止します。必ず**完全なコード**を展開させてください。

### 1.6. Refactoring & Cleanup（リファクタリングとクリーンアップ）
*   **Boy Scout Rule**: 「来た時よりも美しくして立ち去る」。ファイルを触る際は、必ず小さな改善（命名変更、関数抽出）を行います。
*   **No "Later"**: 「後でリファクタリングする」は嘘です。今やるか、永遠にやらないかです。
*   **Cyclomatic Complexity**: 複雑度が高いコードはバグの温床です。早期リターン（Early Return）を活用し、ネストを浅く保ちます。
*   **Dead Code**: コメントアウトされたコード、使われていないインポート、デバッグ用の `console.log` は、コミット前に完全に削除します。
*   **TODO管理**: `// TODO:` を残す場合は、必ずチケット番号または期限を併記します。放置されたTODOは技術的負債です。

### 1.7. Root Cause First Protocol（根本原因優先）
*   **Prohibition**: エラー発生時、原因を特定せずに「とりあえず動く修正（Band-Aid Fix）」を適用することを禁止します。
*   **Process**:
    1.  **Reproduce（再現）**: エラーをローカルで確実に再現させてください。
    2.  **Diagnose（診断）**: ログ、スタックトレース、依存関係ツリー等を分析し、「なぜ起きたか」を言語化してください。
    3.  **Fix Root（根本修正）**: その場しのぎの緩和策ではなく、根本原因を解決してください。
*   **Rationale**: バンドエイド修正は「時限爆弾」です。短期的には動作しますが、環境変更やライブラリ更新時に予測不能な障害を引き起こします。

### 1.8. Config Change Impact Analysis（設定変更影響分析）
*   **Context**: ビルド設定（`next.config.ts`等）、コンパイラ設定（`tsconfig.json`等）のプロジェクト全体設定ファイルの変更は、コードベース全体に予期しない影響を波及させます。
*   **Mandate**:
    1.  **Impact Scan**: 設定変更前に、影響を受ける可能性のある全ファイルを `grep` で特定してください。
    2.  **Approval Gate**: 影響ファイル数が10を超える場合、変更適用前にレビュワーの承認を得てください。
    3.  **Atomic Fix**: 影響のある全ファイルを同一コミット（またはPR）で修正し、半端な状態を防止してください。
*   **Scan Examples**: `trailingSlash` 変更 → 全 `router.push` / `redirect` / `Link href` をスキャン。`paths` エイリアス変更 → 全 `import` 文をスキャン。

### 1.9. Codebase-as-Truth Protocol（コードベースを正とする原則）
*   **Law**: フレームワークやライブラリのAPIを使用する際、「公式ドキュメント」よりも「既存コードベースの実装パターン」を正としてください。ドキュメントは古い場合がありますが、動いているコードは常に最新です。
*   **Action**:
    1.  APIや関数を使用する前に、必ず `grep` で既存の使用例を検索し、プロジェクト内で確立されたパターンに従ってください。
    2.  公式ドキュメントと既存コードの実装が矛盾する場合、既存コードの実装を優先してください。
    3.  新しいパターンを導入する場合は、既存のコードベースとの一貫性を確認し、不整合があれば先に既存コードを統一してください。
*   **The Silent Async Bug Pattern**: データベース書き込み操作やPromiseを返す非同期関数には、**必ず `await` を付与してください**。ESLint `@typescript-eslint/no-floating-promises` の有効化を推奨します。

---

## Part II: インフラとパフォーマンス (Infrastructure & Performance)

### 2.0. インフラストラクチャ基準 (The Golden Quad)
*   **Managed Hosting**: Vercel Pro等、DDoS保護とスケーラビリティを備えたマネージドホスティングを利用します。
*   **BaaS**: Supabase等、DBとバックアップ機能が統合されたBaaSを「唯一の正解」として利用します。
*   **Edge Shield**: Cloudflare等のエッジWAF/CDNを配置し、攻撃と負荷をエッジで吸収します。
*   **Email Deliverability**: Resend等、開発者体験と到達率に優れたメールインフラを採用します。
*   **The Email Deliverability Protocol (DMARC/RFC 8058)**:
    *   **Authentication**: `DMARC`, `SPF`, `DKIM` レコードの設定を完全に義務付けます。未設定のドメインからの送信は**「機能不全」と同義**です。
    *   **One-Click Unsubscribe**: マーケティングメールには `List-Unsubscribe` ヘッダー (RFC 8058) を付与し、1クリックで解約できる導線を実装してください。
*   **Database Connection Pool Protocol（接続プール基準）**:
    *   **Mandatory Pooling**: 直接DBへの接続は禁止。必ず接続プーラー（PgBouncer / Supabase Connection Pooler）を介してください。コネクション枯渇は本番障害の最大要因です。
    *   **Pool Size Formula**: `pool_size = ceil((core_count × 2) + spindle_count)` を基準とし、デフォルトは `max_connections: 10` per process。監視データにより動的に調整してください。
    *   **Idle Timeout**: アイドルコネクションのタイムアウトは **30秒** を目安とし、ゾンビ接続による枯渇を防止してください。
    *   **Transaction vs Session Pooling**: ステートレスなAPIには `transaction mode`、一時テーブルや `SET` 文を使う場合は `session mode` を選択してください（Supabaseのデフォルトはtransaction mode）。

### 2.1. 読み取り最適化 (Read-Optimized Architecture)
*   **事前計算 (Pre-calculation)**: ランキング、集計、複雑なフィルタリング結果は、リクエストごとに計算せず、データ更新時または定期バッチで事前計算し、DBのカラムに保存します。
*   **CQRS**: 参照系と更新系のモデルを分離し、参照系には非正規化された読み取り専用テーブルやマテリアライズドビューの使用を推奨します。
*   **The Hybrid CMS Design Strategy**: 「レイアウト・順序」はJSON (`site_settings.sidebar_order`) で管理し、「コンテンツ」はRDBテーブルで管理するハイブリッド構成を標準とします。

### 2.2. パフォーマンス予算 (Performance Budgets)
*   **Lighthouseスコア**: Performance, Accessibility, Best Practices, SEO の全てで **90点以上** を維持します。
*   **Core Web Vitals**: LCP (2.5s以内), **INP (200ms以内)**, CLS (0.1以内) を厳守します。

### 2.3. アセット最適化 (Asset Optimization)
*   **画像 (Images)**: 次世代フォーマット（AVIF/WebP）を強制します。`next/image` 等の最適化コンポーネントを使用します。
*   **遅延読み込み (Lazy Loading)**: ファーストビュー以外の全てのアセットは遅延読み込みします。
*   **The Fixed Page Protocol**: 利用規約等の「静的だが更新可能なページ」を物理的な `page.tsx` として個別に作成することを厳禁とします。動的ルートを使用し、DBからコンテンツを取得するアーキテクチャを採用してください。

### 2.4. API-Free First Protocol（無料代替優先原則）
*   **Law**: 有料の外部API（Geocoding、住所補完、画像最適化等）を採用する前に、無料代替手段を必ず検討する義務を負います。安易な有料API導入はFinOpsの敗北です。
*   **Free Alternatives Checklist**:
    1.  **既存データからの抽出**: URL解析、メタデータ解析等で必要な情報を取得できないか検討する。
    2.  **クライアントサイドAPI**: Browser Geolocation API、Web Crypto API等のブラウザ標準APIを活用する。
    3.  **オープンデータの活用**: 郵便番号→住所DB、公開統計データ等を利用する。
    4.  **1回取得→DB保存パターン**: 座標等の頻繁に変わらないデータは、初回のみ取得してDB保存し再利用する。
*   **Documentation**: 有料APIを採用する場合は、「なぜ無料代替が不可能か」の理由を実装計画書に明記してください。

### 2.5. Centralized Storage Shield（ストレージ集約管理）
*   **Law**: 画像実体はBaaSストレージ（Origin）に集約し、配信はCDNのOptimization機能を経由させることで、コストとパフォーマンスを両立します。
*   **Cache Maximization**: CDNキャッシュヒット率 **80%以上** を目標とし、静的アセットのオリジン負荷を最小化します。

---

## Part III: 設計によるセキュリティ (Security by Design - DevSecOps)

### 3.0. ゼロトラスト基盤 (Zero Trust Foundation)
> 詳細実装は **`security/000_security_privacy.md`** を参照してください。

*   **Law**: すべてのリクエストは「ネットワーク内部からでも信頼しない」を原則とし、以下のNIST SP 800-207準拠の**5原則**を全システムで実装してください。
*   **Zero Trust 5原則（必須）**:
    1.  **Never Trust, Always Verify（常時検証）**: セッション中も定期的に認証・認可を再検証してください。初回認証の通過がその後のアクセスを保証しません。
    2.  **Least Privilege（最小権限）**: ユーザー・サービス・AIエージェントを問わず、アクセス権は「今まさに必要な最小スコープ」に限定してください。デフォルトはFull Denyです。
    3.  **Assume Breach（侵害前提）**: システムは常に「既に侵害されている」前提で設計してください。侵害検知・ラテラルムーブメント防止・ブラストラジウス最小化が設計の優先事項です。
    4.  **Explicit Verification（明示的検証）**: 全ての入力（ユーザー入力・APIレスポンス・LLM出力）をクライアントとサーバーの両層で検証してください。信頼スコープを明示的に定義し、暗黙的な信頼を排除してください。
    5.  **Continuous Monitoring（継続的監視）**: 全てのアクセスログを収集・分析し、異常なアクセスパターン（異常な時間帯・地域・量）を自動検知するアラートを設置してください。
*   **Zero Trust in Code（実装上の必須チェックリスト）**:
    | レイヤー | 実装義務 |
    |:--------|:--------|
    | **API Edge** | 全エンドポイントへのJWT検証（§3.7）・Rate Limit・CORS制限 |
    | **Service Layer** | 認可チェック（RBAC/ABAC）を全ミューテーション操作に実装 |
    | **DB Layer** | Row Level Security (RLS) でデータの物理的アクセス制御 |
    | **AI Layer** | LLMへの送信前にPII/機密情報フィルタリング（§3.8） |
    | **Monitoring** | 認証失敗・権限昇格試行を即時アラート |

### 3.1. 機密情報管理 (Secrets Management)
*   APIキーや秘密鍵はコードにコミットしません。`.env` ファイルとシークレットマネージャーを使用します。
*   **The Single Source of Config**: コードの各所で直接 `process.env.NEXT_PUBLIC_...` を参照することは禁止です。必ず `src/lib/config` で一元管理し、存在チェック（Validation）を行ってください。

### 3.2. 環境変数テンプレート同期 (Environment Template Sync)
*   **Law**: プロジェクトルートに `.env.example` を常設し、必要な全環境変数の**キーのみ**を記録する義務を負います。
*   **Sync Mandate**: 新しい環境変数を追加した場合、**同一PRで** `.env.example` も更新しなければなりません。
*   **Git Safety**: `.env.local` / `.env.production` 等の実値を含むファイルは `.gitignore` に含め、**厳正にコミットしてはなりません**。

### 3.3. 環境変数ドリフト防止 (Environment Variable Drift Prevention)
*   **Law**: 環境変数の欠落や環境間の不整合（Drift）は、「ローカルでは動くがCI/本番で壊れる」最大の原因です。
*   **Action**:
    1.  **Startup Validation**: アプリケーション起動時に、必須環境変数の存在チェックを実行し、不足している場合は**起動を中断**してください。
    2.  **CI Parity Check**: CIパイプラインにおいて、`.env.example` に記載された全キーがCI環境に定義されていることを検証してください。
    3.  **Type-Safe Config**: 環境変数はZodやio-ts等で**型レベルでバリデーション**し、不正な値を起動時に検出してください。

### 3.4. PII & データスクラビング (PII & Data Scrubbing)
*   **The Privacy Scrubbing Protocol (EXIF Wipe)**: ユーザー投稿画像（UGC）にはGPS座標等の個人情報が含まれる場合があります。クライアントサイドでの画像アップロード処理において、**EXIF情報の物理削除**を義務付けます。
*   **The Console Log Ban**: 本番ビルドにおいて `console.log` を残すことは機密情報漏洩の温床です。`eslint-plugin-no-console` を `error` に設定し、CIで物理的にブロックしてください。

### 3.5. ソフトウェアサプライチェーンセキュリティ (Software Supply Chain Security)
*   **Law**: 依存パッケージは「信頼されたコード」ではなく「潜在的な攻撃ベクター」として扱ってください。サプライチェーン攻撃（typosquatting, dependency confusion, malicious package injection）は2026年最大級の脅威です。
*   **Action**:
    1.  **SLSA Level 2+**: ビルドパイプラインはSLSA (Supply chain Levels for Software Artifacts) Level 2以上を目標とし、ビルドの来歴（Provenance）を自動生成してください。
    2.  **Lockfile Pinning**: `package-lock.json` / `yarn.lock` のIntegrity Hash（`sha512-...`）を検証し、改ざんを検出してください。CIでは必ず `npm ci` を使用します。
    3.  **Dependency Review**: 新規パッケージの追加時は、GitHub Dependency Review Action等で脆弱性・ライセンスを自動スキャンしてください。
    4.  **Sigstore Verification**: 可能な場合、パッケージの署名検証（npm provenance / Sigstore）を有効化し、パッケージの真正性を保証してください。
    5.  **SBOM Generation**: CI/CDパイプラインでSBOM（Software Bill of Materials）を自動生成し、デプロイごとの依存関係スナップショットを保持してください。
*   **Rationale**: 2025-2026年のインシデント（xz-utils backdoor等）が示す通り、信頼されたOSSパッケージへの攻撃は増加の一途です。人間の注意ではなく、自動化された検証メカニズムのみがサプライチェーンを守ります。

### 3.6. シークレットローテーションプロトコル (Secret Rotation Protocol)
*   **Law**: APIキー、DBパスワード、JWTシークレット等の機密情報は定期的に更新しなければなりません。「一度作ったら永久に使う」は最大のセキュリティリスクです。
*   **Rotation Schedule（ローテーション周期）**:
    | 機密種別 | 最大有効期限 | 方法 |
    |:--------|:-----------|:-----|
    | JWT Signing Secret | 90日 | クラウドのSecret Manager + CI/CDで自動ローテーション |
    | DB Password | 90日 | RDS/Supabaseのパスワードリセット + 接続文字列更新 |
    | External API Key | 180日 | ベンダーポータルで再発行 + `.env`シークレット更新 |
    | Service Account / OAuth Client Secret | 365日 | Google Cloud / GitHub Apps での再生成 |
*   **Zero-Downtime Rotation**: ローテーション手順は「旧シークレットの無効化前に新シークレットを有効化する」2フェーズで実施し、サービス停止を防いでください。
*   **Rotation Audit**: ローテーション実施履歴を監査ログに必ず記録し、次回ローテーション日をカレンダーに自動予約してください。
*   **Broken Glass Protocol**: シークレット漏洩が疑われた場合は、**即座に無効化**してください。「様子見」は禁止です。漏洩日時・影響範囲のインシデントレポートを24時間以内に作成してください。

### 3.7. OAuth / OIDC トークン管理プロトコル (OAuth/OIDC Token Handling)
*   **Law**: 認証トークンの誤った実装は、最も発見が遅れるセキュリティホールです。以下の原則を厳守してください。
*   **Token Storage Rules**:
    *   **Access Token**: メモリ（JavaScript変数）のみに保存。`localStorage` / `sessionStorage` への保存は**絶対禁止**（XSS漏洩リスク）。
    *   **Refresh Token**: `HttpOnly; Secure; SameSite=Strict` Cookie のみ。Javascriptからのアクセスを物理的に遮断してください。
*   **Token Validation Mandate**:
    *   サーバーサイドでは、受け取ったJWTの `iss`（発行者）、`aud`（対象者）、`exp`（有効期限）を**全て**検証してください。1つでも欠落した検証は「認証の欠陥」です。
    *   JWTのsignature検証をスキップすることは**絶対禁止**です。
    ```typescript
    // JWT検証の最低限要件（jose / jsonwebtoken等）
    const { payload } = await jwtVerify(token, publicKey, {
      issuer: process.env.JWT_ISSUER,   // iss必須検証
      audience: process.env.JWT_AUDIENCE, // aud必須検証
    });
    // expは自動検証される（ライブラリ標準動作）
    ```
*   **PKCE Mandate**: OAuth2.0の認可コードフローでは、すべてのクライアント（SPA含む）に対してPKCE (Proof Key for Code Exchange) を必須とします。Implicit Flowは**OAuth 2.1（RFC 9700）の正式標準化（2025年末最終化）により、「非推奨」ではなく「正式に削除済み」**です。引き続きImplicit Flowを使用しているシステムは即度復旧してください。

### 3.8. AI/LLM セキュリティ基盤プロトコル (AI/LLM Security Foundation)
> 詳細実装は **`ai/000_ai_engineering.md`** を参照してください。

*   **Law**: AIを組み込むシステムはPrompt Injectionおよびモデル悪用を防ぐ「最小限の防衛ライン」を必ずエンジニアリング層で実装してください。AIセキュリティを「モデル任せ」にすることは設計ミスです。
*   **Prompt Injection 防衛の4原則（必須）**:
    1.  **入力境界の明示**: ユーザー入力とシステムプロンプトは必ず物理的に分離し、ロールを明示してください（`system`/`user`メッセージの厳格な分離）。ユーザー入力をシステムプロンプトに文字列結合することは**絶対禁止**です。
    2.  **出力のサニタイズ**: LLMの出力をHTMLレンダリング・SQLクエリ・OSコマンドに直接渡すことを**禁止**します。必ず出力を型検証・エスケープ処理した上で使用してください。
    3.  **Input Guardrail**: 本番LLMへの送信前に、PII（個人識別情報）・機密情報・インジェクション試行パターンを検出・マスクするフィルタリング層を設けてください。
    4.  **Output Guardrail**: LLM出力を公開する前に、有害コンテンツ・PII漏洩・機密情報の混入を検出するフィルタリング層を設けてください。
*   **LLM固有の最小セキュリティ設定**:
    | 設定項目 | 推奨値 | 目的 |
    |:--------|:-------|:-----|
    | `max_tokens` | 出力用途に合わせた上限設定 | トークン枯渇攻撃の防止 |
    | `temperature` | 本番用途では 0.0–0.7 | 出力の予測可能性確保 |
    | User Rate Limit | ユーザーあたり適切なRPM制限 | AI FinOps / DDoS対策 |
    | API Timeout | 30秒以下 | ハングリクエストの排除 |
*   **Function Calling / Tool Use セキュリティ**:
    *   AIに付与するツール（Function）は「最小権限の原則」に基づき、必要最小限のスコープに限定してください。
    *   AIが実行するDB操作・外部APIコールはすべて**人間が定義したホワイトリスト内**に限定し、動的なコード生成・実行は**禁止**です。
    *   AIによるミューテーション操作（書き込み・削除）には必ず「Human-in-the-Loop」確認ステップを経てください。
*   **Indirect Prompt Injection 防衛**:
    *   Webページ・ドキュメント・メールの内容をLLMに読み込ませる場合、その外部入力がシステムプロンプトを乗っ取ろうとする間接的な注入（Indirect Prompt Injection）に対し、入力の信頼レベルをシステムプロンプトより常に低く設定してください。
    ```typescript
    // 安全なメッセージ構造の原則（OpenAI / Anthropic API共通）
    const messages = [
      { role: 'system', content: SYSTEM_PROMPT },          // システム設定（信頼レベル: 高）
      { role: 'user',   content: sanitize(userInput) },    // ユーザー入力（信頼レベル: 低）
      // ❌ 禁止: `${SYSTEM_PROMPT} ${userInput}` での文字列結合
    ];
    ```

### 3.9. 内部不正対策プロトコル (Insider Threat Prevention)
*   **背景**: 外部攻撃者だけでなく、**内部関係者（従業員・委託先・元従業員）**が意図的または過失により引き起こすセキュリティインシデントは、DBIR 2025 データで全インシデントの約 20% を占めます。Zero Trust（§3.0）の「Assume Breach」は内部不正にも適用されます。
*   **必須対策（4層防御）**:
    1.  **Least Privilege + JIT Access（最小権限 + ジャストインタイムアクセス）**: 日常業務に本番DBへの永続アクセスは不要です。本番データにアクセスする場合はJIT（Just-In-Time）プロビジョニングで一時的権限を付与し、作業完了後に即時失効させてください。ツール例: HashiCorp Vault Dynamic Secrets / AWS IAM Identity Center。
    2.  **Privileged Access Workstation (PAW)**: 管理者権限での作業は、専用の「特権アクセスワークステーション」または分離されたブラウザプロファイルから行い、日常業務端末と物理的に分離してください。
    3.  **User Behavior Analytics (UBA)**: 通常パターンから逸脱したアクセス（深夜の大量データダウンロード・通常の作業ディレクトリ以外へのアクセス）を自動検出するUBA（SIEM連携）を導入してください。アラートは SOC または責任者へ即時通知。
    4.  **Separation of Duties（職務分掌）**: コードのコミット権限・本番デプロイ権限・データ閲覧権限を**同一人物が全て保持することを禁止**します。重要操作は必ず二者確認（Four-Eyes Principle）を実施してください。
*   **オフボーディング・プロトコル（退職者対応）**:
    | タイムライン | 対応内容 |
    |:------------|:--------|
    | 退職当日 | 全認証情報の一括無効化（SSO・API Key・SSH Key・MFA）。`gitleaks` でコミット履歴をスキャン |
    | 24時間以内 | 本番システムのアクセスログを72時間分レビューし、異常データ持ち出しがないか確認 |
    | 72時間以内 | CODEOWNERSの更新、チームSlackの強制退会、GitHubオーガニゼーション除名 |
    ```bash
    # オフボーディングチェックリスト（自動化推奨）
    # 1. GitHub org からユーザーを除名
    gh api orgs/{org}/members/{username} -X DELETE
    # 2. 有効APIキーをリスト（Vaultの場合）
    vault list auth/token/accessors | xargs -I{} vault token lookup -accessor {}
    ```
*   **根拠**: 内部不正の被害額は外部攻撃の平均3.5倍（Ponemon Institute 2025）。技術的対策に加え、「透明性のある監視文化（Blameless §19.4とは別に、意図的不正への抑止）」を醸成することが重要です。

---

## Part IV: 技術的負債とクリーンアップ (Technical Debt & Cleanup)

### 4.0. 負債返済戦略 (Debt Paydown Strategy)
*   スプリントの **20%** は技術的負債の返済（リファクタリング、ライブラリ更新）に充てます。
*   **The TODO/FIXME Protocol (Ticket First)**: コード内の `// TODO:` や `// FIXME:` は、チケット（Issue）化されなければ「単なる落書き」です。TODOコメントを残す際は、必ず対応する Issue 番号を併記することを義務付けます。番号のないTODOはPRで却下されます。

### 4.1. テックレーダー & 依存関係ガバナンス (Tech Radar & Dependency Governance)
*   **定期更新**: 依存ライブラリは四半期ごとに更新し、常に「安全な最先端」を維持します。
*   **Dependency Watch (24-Hour Mandate)**: `npm audit` を定期的に実行してください。**High/Critical** な脆弱性が発見された場合は、発見から **24時間以内** にパッチを適用するか、緊急の回避策を講じることを義務付けます。
*   **The Dependency Override Protocol**: `legacy-peer-deps=true` は全ての依存関係チェックを無効化する「法治国家の放棄」であり憲法違反とします。React 19等の互換性エラーが出た場合は、`package.json` の `overrides` フィールドを使用してください。
*   **The License Quarantine (AGPL Block)**: ライセンスガバナンスの詳細については、`600_security_privacy.md` を参照し、**AGPL** の使用防止を徹底してください。

### 4.2. Lockfile整合性 (Lockfile Integrity Protocol)
*   **Law**: ロックファイル（`package-lock.json` / `yarn.lock`）の不整合によるCI失敗を「大罪」として禁じます。
*   **CI Discipline**: CIパイプライン上では必ず `npm ci` を使用し、ロックファイルを厳密に守らせてください。
*   **Silver Bullet**: ローカルとCIで挙動が異なる場合、`rm -rf node_modules package-lock.json && npm install` でロックファイルを完全に再生成してください。
*   **Prohibition**: 依存関係変更後にロックファイルをコミットせずにPushすることを禁止します。

### 4.3. Dead Export検出 (Dead Export Detection)
*   **Law**: エクスポートされた関数・型・定数の使用箇所がゼロになった場合、即座に除去しなければなりません。
*   **Action**: 監査時は `grep -r "functionName" src/` で全エクスポートの使用箇所を確認してください。使用箇所ゼロのエクスポートは即座に除去し、関連する型定義も連鎖クリーンアップしてください。
*   **The Backup File Ban (No .bak)**: バックアップファイル（`.bak`, `.old`, `_copy`）はGit管理下においてはノイズであり即時削除してください。バックアップはGitの履歴です。
*   **The Exhaustive Reference Scan (Grep First)**: ファイルを削除・リネームする際は、必ずプロジェクト全体を対象にファイル名で `grep` 検索を行い、全ての参照箇所を特定・排除してから実行してください。

### 4.4. Ghost Feature Ban & Revival（ゴースト機能禁止と復活）
*   **The Ghost Feature Ban**: ユーザー導線が存在しない機能（公開されていない管理画面コード等）は負債です。YAGNI原則に従い、物理削除してください。
*   **The Ghost Feature Revival (Full-Stack Coherence)**: 管理画面で設定を変更しても、フロントエンドで何も変化しない機能（Ghost Feature）は、システムへの信頼を破壊するバグです。管理画面の設定項目を追加する際は、必ずフロントエンドでの反映ロジックを同時に実装し、結合テストを行ってください。

---

## Part V: AIファースト開発 (AI-First Engineering)

### 5.0. Prompt Driven Development (PDD)
*   **原則**: コードは人間が書くものではなく、AIに書かせるものです。「プロンプト」こそが真のソースコードです。
*   **AIフレンドリー**: 変数名や関数名は、AIが文脈を理解しやすいように、極めて記述的（Descriptive）にします（例: `x` ではなく `daysSinceLastLogin`）。

### 5.1. RAG最適化 & Schema Trust (RAG Optimization)
*   **モジュール化**: ファイルサイズは小さく保ち（Atomic）、AIのコンテキストウィンドウを圧迫しないようにします。
*   **Explicit Imports**: `import` ステートメントは必ずファイルの最上部に記述してください。関数内や条件分岐内でのインポートは禁止です。
*   **セマンティック構造**: ディレクトリ構造は機能単位（Feature-based）で整理し、AIが関連ファイルを見つけやすくします。
*   **Schema Trust Protocol (No Ghost Columns)**: 設計書に予定されているが、DBマイグレーションがまだ適用されていないカラム名をクエリで使用することを禁止します。

### 5.2. AI Hygiene & Anti-Blindness（AI衛生管理）
*   **The Anti-Blindness Protocol**: AIが生成したコードに含まれる省略記法（`// ...`）を、そのままファイルに保存することを禁止します。必ず完全なコードを展開させてください。
*   **Human Verification Loop**: AI生成コードは「下書き」であり、必ず人間が検証・修正するフローを維持してください。AIの出力を無批判にコミットすることは禁止です。

### 5.3. AI Code Review Governance（AIコードレビュー統治）
*   **Law**: AI（Copilot, Cursor, Cody等）が生成したコードは、人間が書いたコードと**同等以上の厳格さ**でレビューしなければなりません。「AIが生成した」は品質保証の免罪符にはなりません。
*   **Action**:
    1.  **Provenance Tagging**: AIが生成したコードブロックには、コミットメッセージまたはPR説明で `[AI-Generated]` タグを付与し、レビュアーの注意を喚起してください。
    2.  **Hallucination Guard**: AI生成コードに含まれる外部ライブラリのAPI呼び出しは、必ず公式ドキュメントまたは `node_modules` 内の型定義と照合してください。存在しないAPIの「ハルシネーション」は最も発見が遅れるバグです。
    3.  **Security Audit**: AI生成コードにおけるセキュリティパターン（入力バリデーション、SQL Injection防止、XSS対策）は、人間が明示的に検証してください。AIはセキュリティ要件を「推測」で省略する傾向があります。
    4.  **License Compliance**: AIが生成したコードが、既存のOSSコードの著作権やライセンスに抵触しないことを確認してください。
*   **Rationale**: AI Copilotの普及により、コード生成速度は飛躍的に向上しましたが、品質・セキュリティ・ライセンスのリスクも増大しています。「速く書ける」ことと「正しく書ける」ことは別問題です。

### 5.4. LLM Context Optimization（LLMコンテキスト最適化）
*   **Law**: AIエージェントとの協業において、コードベースの「AIフレンドリネス」は生産性に直結します。AIが効率的にコードを理解・生成できる構造を維持してください。
*   **Action**:
    1.  **File Size Budget**: 1ファイルあたり **300行以下** を目標とし、AIのコンテキストウィンドウに収まるサイズを維持してください。超過する場合は機能分割を検討してください。
    2.  **Self-Documenting Types**: 型定義は「ドキュメント」として機能します。`string` ではなく `BrandedType`（例: `type UserId = string & { __brand: 'UserId' }`）を使用し、AIが型から意図を推論できるようにしてください。
    3.  **Contextual Comments**: 「何をしているか」ではなく「なぜそうしているか」をコメントで記述してください。AIは「What」はコードから推論できますが、「Why」はコメントなしでは推論不可能です。
    4.  **llms.txt / AGENTS.md**: プロジェクトルートに `llms.txt` または `AGENTS.md` を配置し、AIエージェントに対するプロジェクトの概要、アーキテクチャ、制約を記述してください。
*   **Rationale**: 2026年のソフトウェア開発は「人間がAIに指示する」モデルへ移行しています。AIが理解しやすいコードベースは、開発速度と品質の両方を向上させます。

---

## Part VI: グリーンコーディングとサステナビリティ (Green Coding & Sustainability)

### 6.0. エネルギー効率 (Energy Efficiency)
*   **アルゴリズム最適化**: 計算量（O記法）を意識し、無駄なCPUサイクルを消費しないコードを書きます。これはバッテリー寿命と地球環境の両方を守ります。
*   **ダークモード**: 有機EL（OLED）デバイスでの消費電力を抑えるため、真の黒（#000000）を使用したダークモードを推奨します。
*   **Idle-Aware Processing**: バックグラウンドジョブやバッチ処理は、システム負荷の低い時間帯（オフピーク）に実行するよう設計し、電力消費ピークを分散させてください。

### 6.1. データ転送量最適化 (Data Transfer Optimization)
*   **圧縮**: 画像や動画は必ず最適化（AVIF/H.265）し、ネットワーク帯域の浪費を低減します。
*   **Cache Maximization**: CDNキャッシュヒット率 **80%以上** を目標とし、静的アセットのオリジン負荷とカーボンフットプリントを最小化します。
*   **Payload Diet**: GraphQL/REST APIはクライアントが必要とするフィールドのみを返却し、Over-fetchingを禁止します。各エンドポイントで平均ペイロードサイズを計測・管理してください。

### 6.2. Software Carbon Intensity (SCI) 計測
*   **Law**: Green Software Foundation (GSF) が定義する SCI (Software Carbon Intensity) スコアを四半期ごとに算出し、改善トレンドを記録してください。SCI = (E × I) + M
*   **計測対象**: CI/CDパイプライン、`npm test` の実行、本番環境の常時稼働サービスのCO₂消費を追跡対象とします。
*   **Carbon-Aware Scheduling**: クラウドプロバイダーのカーボン強度APIを利用し、再生可能エネルギー割合が高いリージョン・時間帯にバッチジョブをスケジュールすることを推奨します。
    ```typescript
    // carbon-aware-sdk 活用例
    import { CarbonAwareComputing } from '@carbon-aware/sdk';
    const bestWindow = await carbonAware.getBestExecutionWindow({
      location: ['japaneast', 'westus2'],
      duration: 30, // minutes
    });
    ```

### 6.3. Green Architecture Principles（グリーンアーキテクチャ原則）
*   **Serverless-First for Sporadic Workloads**: 散発的なワークロードには常時稼働サーバーを避け、サーバーレス（Cloud Functions/Lambda）を優先して使用してください。アイドル時のCPU消費ゼロが設計原則です。
*   **Right-Sizing Mandate**: 本番環境のインスタンスサイズは、実際の負荷メトリクス（CPU使用率 < 60% が常態）を確認した上で設定してください。過剰プロビジョニングはFinOpsとGreenOpsの両方の敗北です。
*   **Data Gravity Awareness**: データ処理はデータが存在するリージョンで完結させ、リージョン間データ転送（Egress）を最小化してください。転送コストはCO₂排出の直接指標です。

---

## Part VII: ゼロバグ・ポリシー (The "Zero Bug Policy")

### 7.0. 修正優先 (Fix First)
*   既知のバグがある状態で新機能を開発しません。バグ修正は最優先事項です。

### 7.1. 24時間ルール (24-Hour Rule)
*   クリティカルなバグ（データ損失、セキュリティ、主要機能停止）は、発見から **24時間以内** に修正します。

### 7.2. Framework Signature Reality (Codebase as Truth)
*   **Context**: ライブラリやフレームワークの公式ドキュメントは更新が遅れることがあります。
*   **Law**: 公式ドキュメントよりも「既存コードベースのシグネチャ（実際の型定義）」を正とします。APIを使用する前に、必ず `grep` やIDEの定義ジャンプで既存使用例と型定義を確認してください。

### 7.3. Fix Twice Principle（再発防止）
*   バグを修正する際は、「そのバグを直す (Fix Once)」だけでなく、「二度と同じバグが起きない仕組み（Lint追加、型厳格化、テスト追加）を作る (Fix Twice)」までをワンセットとします。

---

## Part VIII: 継続的学習と検証 (Continuous Learning & Verification)

### 8.0. 最新情報の確認義務 (Latest Info Protocol)
*   **開発着手前**: コードを書く前に、必ず対象技術の公式ドキュメントや最新のリリースノートを確認します。古い情報に基づいた実装は手戻りの元です。
*   **非推奨チェック**: 使用しようとしているAPIが Deprecated になっていないか確認します。

### 8.1. トレンドの把握 (Trend Awareness)
*   シリコンバレーの最新トレンド（AIエージェント、Privacy Manifests等）を常にキャッチアップし、ルール自体も進化させ続けます。

### 8.2. Crystallization Protocol（知識の結晶化）
*   **Law**: 機能実装完了後、その過程で得られた「暗黙知」「新しいパターン」「ハマったポイント」は、設計書（Blueprint）やルールファイルに文書として還元する義務を負います。
*   **Rationale**: 知識がコードにのみ存在する状態は「経験の揮発」です。得られた学びを即座にドキュメント化する習慣がチームの生産性を指数関数的に向上させます。

---

## Part IX: 互換性とテスト (Compatibility & Testing)

### 9.0. 実機テスト (Real Device Testing)
*   シミュレーターだけでなく、必ず実機（iOS, Android）でテストを行います。特にカメラ、GPS、生体認証などのハードウェア機能は実機必須です。

### 9.1. ブラウザ互換性 (Browser Compatibility)
*   Chrome, Safari (iOS/macOS), Firefox, Edge の最新2バージョンをサポートします。特にSafari（iOS）特有のバグ（100vh問題など）に注意します。

### 9.2. セルフチェックリスト (Self-Check List)
*   PRを出す前に、開発者は自身のコードをレビューし、「警告ゼロ」「コンソールエラーなし」「不要なログ削除」を確認します。

### 9.3. Testing Trophy Protocol（テスト戦略・比率の義務化）
*   **Context**: テストは「多ければいい」というものではありません。Kent C. Doddsの **Testing Trophy** に基づき、ROI（投資対効果）を最大化するテスト比率を義務付けます。
*   **Testing Trophy（推奨比率）**:
    | レイヤー | 比率 | 説明 | ツール例 |
    |:--------|:-----|:----|:--------|
    | **Static（静的解析）** | 基盤 | TypeScript + ESLint。ビルド前に型エラー・Lintエラーをゼロにする | `tsc --noEmit`, `eslint` |
    | **Unit（単体）** | 30% | ビジネスロジック、純粋関数、データ変換。UIコンポーネントの単体テストは原則不要 | `vitest`, `jest` |
    | **Integration（統合）** | 50% | APIエンドポイント、DBとの結合、Server Actions。**最もROIが高い** | `vitest` + `supertest` / Playwright API |
    | **E2E（エンドツーエンド）** | 20% | クリティカルパスのみ（ログイン・決済・主要CRUD）。全網羅は禁止 | `Playwright`, `Cypress` |
*   **Prohibitions**:
    *   実装コードと1:1対応する「コードコピーテスト」は禁止。テストは「振る舞いを検証」するものです。
    *   `any` キャストや非同期のハンドリング漏れを含むテストコードは、プロダクションコードと同等の品質基準で却下します。
*   **Coverage Targets**:
    *   ビジネスロジック・Service層の**Line Coverage: 80%以上**を必須とします。
    *   ビジネスロジック・Service層の**Mutation Score: 70%以上**を必須目標とします。UIコンポーネントのLine Coverageを追いかけることは禁止（意味がない）。
*   **Mutation Score（変異スコア）とは**: 実装コードに意図的なバグ（Mutant）を注入し、テストがそれを検出できるか検証する高度テスト品質指標です。「テストがあるだけ」ではなく「テストが本当に機能しているか」を計測します。
    ```bash
    # Stryker Mutant（TypeScript向け）による設定例
    # stryker.config.mjs
    export default {
      mutate: ['src/lib/**/*.ts'],          // 変異対象（ビジネスロジック層のみ）
      thresholds: { high: 80, low: 70, break: 60 }, // Mutation Score下限
      reporters: ['html', 'dashboard'],
    };
    ```

### 9.4. Property-Based Testing & Chaos Engineering（高度テスト戦略）
*   **Property-Based Testing (PBT)**:
    *   **対象**: データバリデーション、数値計算、ソートアルゴリズム、シリアライズ/デシリアライズ処理など、入力値の組み合わせが膨大な箇所に適用してください。
    *   **ツール**: `fast-check` (TypeScript) を使用し、境界値を網羅的に生成させてください。ランダムな入力でバグを発見する確率は通常のUnit Testより桁違いに高い。
    ```typescript
    // fast-check によるProperty-Based Testing例
    import * as fc from 'fast-check';
    test('金額変換は非負整数で常に安全であること', () => {
      fc.assert(fc.property(
        fc.integer({ min: 0, max: 1_000_000 }),
        fc.integer({ min: 0, max: 99 }),
        (yen, sen) => {
          const result = formatPrice(yen, sen);
          return result.includes('¥') && !result.includes('NaN');
        }
      ));
    });
    ```
*   **Chaos Engineering（カオスエンジニアリング）**:
    *   **原則**: 「障害は予防できない。耐えられるか検証せよ。」
    *   **GameDay Mandate**: 四半期に1回、以下のシナリオを計画的に演習（GameDay）を実施し、システムの耐障害性を検証してください。
        | シナリオ | 検証内容 |
        |:--------|:--------|
        | **DB接続断（30秒）** | Circuit BreakerとFallback動作確認 |
        | **外部APIタイムアウト（5秒）** | Timeout + Retry + DLQへの流入確認 |
        | **トラフィック10倍スパイク** | Autoscalingとレート制限の動作確認 |
        | **ランダムPodキル (Kubernetes)** | ヘルスチェック・再起動・データ整合性確認 |
    *   **Chaos Test Automation（自動化ツール選定基準）**:
        | ツール | 適合環境 | 主な機能 |
        |:------|:--------|:--------|
        | **Chaos Monkey** (Netflix OSS) | AWS/EC2中心の環境 | ランダムインスタンス終了 |
        | **Litmus Chaos** | Kubernetes | Pod/Node/Network障害の宣言的定義 |
        | **Gremlin** | マルチクラウド | SaaS型・GUI管理・安全停止機能 |
        | **Toxiproxy** | ローカル/CI | ネットワーク遅延・断絶のプログラマブル注入 |
        ```yaml
        # Litmus ChaosExperiment 定義例（Pod削除）
        apiVersion: litmuschaos.io/v1alpha1
        kind: ChaosEngine
        metadata:
          name: pod-delete-engine
        spec:
          engineState: 'active'
          chaosServiceAccount: litmus-admin
          experiments:
            - name: pod-delete
              spec:
                components:
                  env:
                    - name: TOTAL_CHAOS_DURATION
                      value: '30'    # 30秒間
                    - name: CHAOS_INTERVAL
                      value: '10'   # 10秒ごとに1Pod削除
        ```
    *   **Blast Radius Constraint**: Chaos実験は必ず「影響範囲（Blast Radius）を最小化」した状態で実施し、本番データの破壊を防いでください。最初はステージング環境から開始します。

### 9.5. Visual Regression Testingプロトコル（ビジュアル回帰テスト）
*   **Context**: Unit TestやIntegration Testでは検出できない「目に見える崩壊（UIリグレッション）」を自動検出するため、Visual Regression TestingをCIの一部として義務付けます。
*   **ツール選定基準**:
    *   **Storybookベース（小～中規模）**: Storybook + `@chromatic-com/storybook` によるコンポーネント単位のイメージスナップショット比較。
    *   **Playwrightベース（ページ全体）**: Playwright `expect(page).toHaveScreenshot()` によるフルページスクリーンショット比較。クリティカルパス（ログイン・チェックアウト・ダッシュボード）に必ず適用。
    ```typescript
    // Playwright Visual Regressionテストの例
    import { test, expect } from '@playwright/test';
    test('ダッシュボード ビジュアル回帰テスト', async ({ page }) => {
      await page.goto('/dashboard');
      await page.waitForLoadState('networkidle');
      await expect(page).toHaveScreenshot('dashboard-baseline.png', {
        maxDiffPixelRatio: 0.01, // 1%ぞの差専上限を許容
      });
    });
    ```
*   **スナップショット運用ルール**:
    *   **ベースライン更新手順**: 正当なUI変更時は必ず `--update-snapshots` フラグでベースラインを意図的に更新し、PRに差分坓を添付してレビュアーが目視で確認してください。
    *   **禁止**: スナップショットの差分を声明なしに自動発生・CI内で配布することを禁止します。
    *   **噪音不変垢の確保**: アニメーション・ダイナミックコンテンツはスナップショット前に必ず停止（`waitForLoadState('networkidle')`）を実装し、フレークテストを防止してください。

---

## Part X: Git とバージョン管理 (Git & Version Control)

### 10.0. Trunk Based Development（トランクベース開発）
*   **原則**: 長寿命のブランチは廃止し、短命のブランチから `main` へ頻繁に（毎日）マージします。
*   **Stacked Diffs**: 巨大なPRを避け、依存関係のある小さなPRを積み重ねる手法を推奨します。
*   **Branch Naming Standard**: ブランチ名は `type/summary` 形式で統一します（例: `feat/user-profile`, `fix/login-bug`）。Types: `feat`, `fix`, `refactor`, `chore`。

### 10.1. コミット & PR基準 (Commit & PR Standards)
*   **Conventional Commits**: `type(scope): subject` 形式を厳守します。本文にはプロジェクト設定言語で詳細を記述します。
*   **Atomic Commits**: 1つのコミットには「1つの論理的変更」のみを含めます。
*   **The Pull Request Template Protocol**: `.github/pull_request_template.md` を作成し、"Type of change", "How to test", "Screenshots" の3項目は必須です。
*   **The CI Timeout Protocol**: すべてのCIジョブには必ず `timeout-minutes: 10` を設定してください。10分を超えるビルドは「設計ミス」とみなします。
*   **100行ルール**: PRは小さく保ちます。`main` への直接プッシュは禁止し、CI通過とレビュー承認を必須とします。
*   **Husky Guard (Deep Defense)**: 全てのプロジェクトにおいて、`pre-push` フックによる `main` ブランチへの直接プッシュ禁止を義務とします。
*   **The Automated Git Hooks Protocol (Lint Staged)**: `lint-staged` を導入し、コミットされるファイルに対して自動的に `eslint --fix` と `prettier --write` を実行することを義務付けます。
*   **The Red Button Checklist**: 本番デプロイ直前には、Legal、Security（RLS）、FinOps（Spend Cap）、Dataの指差し確認を義務付けます。
*   **Branch Hygiene Mandate**: マージ済みのブランチは即時削除。`git branch --merged` の確認をエンジニアの呼吸としてください。
*   **Omnichannel Check**: レビュー時は「Web以外でも利用可能か？」を最優先で確認します。
*   **Deployment Safety Protocol**:
    *   **Supreme Directive: The AI Git Ban**: AIによるGit操作の厳格な禁止については、`000_core_mindset.md` の Rule 8.1 を参照。
    *   **The Automated Deployment Mandate (CD First)**: 本番環境へのデプロイを手動コマンドで行うことは**完全禁止**。CI/CDパイプライン経由のみ。
    *   **The Architectural Preservation Protocol**: プロジェクトの中核機能ファイルには `@preservation_level CRITICAL` ヘッダーを付与し、AIの独断での破壊的変更を防止してください。
*   **セキュリティ**: APIキー等の機密情報は厳正にコミットせず、CIでシークレットスキャン（TruffleHog）を義務付けます。
*   **The Lockfile Regeneration Reflex**: CIのみが失敗する場合、まず `rm -rf package-lock.json node_modules && npm install` でLockfileを再生成してプッシュしてください。
*   **The Connection Verification Protocol**: データベース接続エラー発生時は、まず `.env.local` の接続先を確認してください。

### 10.2. The IPv6 Deployment Protocol
*   **Law**: CI環境において、Supabase (PostgreSQL) への接続が IPv6 名前解決の不備により失敗する現象を、アプリケーションのコード修正で解決しようとしてはなりません。
*   **Action**: 必ず Connection Pooler (IPv4) 経由の接続を確立してください。

### 10.3. The Branch Hygiene Mandate (Garbage Collection)
*   **Law**: 作業ブランチを放置することは、環境差異による事故の最大の原因です。
*   **Action**: タスク完了報告の直前に、必ず `git branch --merged` を確認し、マージ済みの作業ブランチを削除してください。

### 10.4. The Migration Immutability Protocol (History Protection)
*   **Law**: 将来の実装予定にあるカラム名を、実際のDBマイグレーション完了前にコードで使用することは禁止です。
*   **Action**: クエリで使用するカラムは、必ず「現在、確実に存在する」ものに限定してください。未実装機能のデータはアプリケーション層で定数として補完してください。

### 10.5. The Version Alignment Protocol (Zod/RHF)
*   **Law**: `zod`, `react-hook-form`, および `@hookform/resolvers` のバージョン不整合は「ランタイムでのバリデーション不全」を引き起こします。
*   **Action**: フォーム関連ライブラリは一括でアップデートを行ってください。バージョン不整合による型エラーを `as any` で握りつぶすことは禁止です。

### 10.6. The Zod Nullable DB Alignment Protocol（DB NULL対応義務）
*   **Law**: DBスキーマで `NULL` を許容するカラムに対応するZodスキーマは、`.optional()` ではなく **`.nullable()`** を使用しなければなりません。
*   **Action**:
    1.  DBカラムが `DEFAULT NULL` の場合、Zodフィールドは `z.string().nullable()` を適用してください。
    2.  UI側で `undefined` として扱う必要がある場合は、`.nullable().transform(v => v ?? undefined)` で明示的に変換してください。
    3.  DBマイグレーションで `NOT NULL` 制約を変更した場合、Zodスキーマも**同時に更新**してください。

---

## Part XI: ドキュメント運用 (Documentation Ops)

### 11.0. Living Documentation（生きたドキュメント）
*   **Mermaid.js**: アーキテクチャ図は画像ではなくコード（Mermaid）で管理し、陳腐化を低減します。
*   **ADR**: 技術的な意思決定は `docs/adr` にMarkdownで記録します。
*   **The Live Docs Requirement (DX)**: APIエンドポイント定義は Swagger UI や ReDoc を通じて常時可視化されなければなりません。実装とドキュメントの乖離は許されません。

### 11.1. Docs as Code & Freshness（ドキュメント鮮度）
*   **Docs as Code**: ドキュメントはコードと等価であり、Gitで管理し、PRレビューの対象とします。ドキュメント更新なきコード変更はマージ禁止です。
*   **鮮度維持**: リンク切れチェックを自動化し、主要ルールは四半期ごとに見直します。

### 11.2. README Standard Protocol（README必須セクション基準）
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

---

## Part XII: エンジニアリング品質プロトコル (Engineering Quality Protocols)

### 12.1. The Zero-Warning Lint Protocol
*   **Law**: CI全通過の真の意味は、警告数0です。`npm run lint` の結果は、必ず警告数0でなければなりません。未使用変数は即座に削除してください。

### 12.2. The Clean Import Protocol
*   **Law**: `import` ステートメントは必ずファイルの最上部に記述してください。関数や制御フロー内でのインポートは厳禁です。

### 12.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: 管理画面上の専門用語や指標には必ず `Tooltip` を付与し、「それが何であり、ビジネスにどう影響するか」を素人の言葉で解説してください。

### 12.4. Localization First Protocol
*   **Action**: エラーメッセージやバリデーションメッセージは、全てプロジェクト設定言語にローカライズしてください。

### 12.5. The Recursive Logic Ban (Infinite Recursion Shield)
*   **Law**: 終了条件が不明確な「深い再帰処理」を禁止します。再帰的な構造を扱う場合は、必ず **Depth Limit** を定数として定義してください。
*   **Reason**: スタックオーバーフローだけでなく、無限DB読み込みを誘発し、クラウド破産を招くためです。

### 12.6. The Atomic Commits Protocol（原子的コミット基準）
*   **Law**: 1つのコミットには「1つの論理的変更」のみを含めてください。フォーマット修正と機能追加を混在させてはなりません。
*   **Revertability**: バグ発生時に「そのコミットだけ」をRevertすれば修正される粒度を維持してください。
*   **Prohibition**: WIPコミットの本番ブランチへのプッシュを禁止します。

### 12.7. The Conventional Commits Standard（セマンティックコミット規約）
*   **Law**: コミットメッセージは `type(scope): subject` 形式を遵守してください。
*   **Types**: `feat`, `fix`, `refactor`, `perf`, `docs`, `style`, `test`, `chore`, `security`
*   **Breaking Change**: 破壊的変更がある場合は `feat!:` または footer に `BREAKING CHANGE:` を記載してください。

### 12.8. The Code Review Protocol（コードレビュー基準）
*   **Law**: コードレビューは品質の最終防衛線です。PRサイズは **400行以下** を目安とします。
*   **レビュー観点チェックリスト**:
    | 観点 | チェック内容 |
    |:-----|:-----------|
    | **型安全性** | `as any` の使用禁止、適切な型定義 |
    | **セキュリティ** | PII露出なし、アクセス制御確認 |
    | **パフォーマンス** | N+1クエリなし、不要な再レンダリングなし |
    | **FinOps** | 無限ループDB読み込みなし、キャッシュ戦略適切 |
    | **国際化** | UI文言が運用者の母国語で記述されているか |
    | **アクセシビリティ** | キーボード操作可能、`aria-label` 適切 |
    | **レジリエンス** | タイムアウト設定・Retryロジック・Circuit Breaker確認 |
    | **可観測性** | 新エンドポイントにメトリクス計装が含まれているか |
*   **AI-Assisted Review Governance**:
    *   GitHub Copilot Code Review, CodeRabbit等のAI Reviewツールを活用することを推奨しますが、以下を遵守してください。
    *   **AI Review ≠ Human Review**: AI Reviewの指摘は「参考情報」であり、Human Reviewの免除にはなりません。最終承認は人間が行います。
    *   **False Negative Awareness**: AIは「ロジックの意図の正しさ」「ビジネス要件との整合性」を確認できません。この観点は人間が責任を持って確認してください。
    *   **Security Override**: セキュリティ観点（認証・認可・PII）はAI Reviewに頼らず、人間が必ず明示的に確認してください。

### 12.9. The CODEOWNERS Protocol（コード所有権管理）
*   **Law**: `.github/CODEOWNERS` ファイルでディレクトリごとの所有者を定義してください。CODEOWNERSに指定された所有者のApproveをPRマージの必須条件としてください。

### 12.10. The Git Hooks Automation Protocol（三層防御）
*   **Law**: 「気をつける」運用ルールではなく、「物理的に不可能にする仕組み」で品質を担保してください。
*   **三層防御**:
    | レイヤー | フック | 内容 | ツール例 |
    |:--------|:-----|:-----|:--------|
    | **Pre-Commit** | `pre-commit` | Lint・フォーマット自動実行 | `husky` + `lint-staged` |
    | **Commit-Msg** | `commit-msg` | Conventional Commits検証 | `commitlint` |
    | **Pre-Push** | `pre-push` | 保護ブランチへの直接Push物理ブロック | ブランチ名チェック |
*   `--no-verify` でのフック迂回はゼロトレランスとし禁止です。

### 12.11. The Branch Naming Convention（ブランチ命名規約）
*   **Law**: ブランチ名は `type/summary` 形式で統一してください。
*   **Types**: `feat/`, `fix/`, `refactor/`, `chore/`, `hotfix/`
*   **Merge Strategy**: Squash Mergeを前提とし、コミット履歴を汚さないでください。
*   **Branch Cleanup Protocol**: マージ済みブランチは即座に削除してください。

### 12.12. The SSOT Sync Protocol（SSOT同期プロトコル）
*   **Law**: 作業ブランチのマージ完了後、必ずローカルの `main` ブランチをリモートの状態と**100%同期**させなければなりません。
*   **Action**:
    1.  `git checkout main` → `git pull origin main` → マージ済みブランチの削除
    2.  新規タスク開始前にローカルの `main` が最新であることを確認してください。
    3.  古い `main` からブランチを切って開発を開始することを禁止します。

---

## Part XIII: 高度アーキテクチャ原則 (Advanced Architectural Mandates)

### 13.1. The Trinity DTO Mandate（DTO三位一体義務）
*   **Law**: いかなる機能実装においても、以下の3原則を遵守しないコードは憲法違反となり、即時修正の対象です。
    1.  **Security (PII Defense)**: 生データ（Raw Row）の出力は禁止です。必ず **DTO (White-list)** を経由し、機密情報を物理的に遮断してください。
    2.  **Stability (Frontend Shield)**: DBスキーマとUIを直結させてはなりません。Mapper関数という「防波堤」を築き、変更の影響をサーバー内で吸収してください。
    3.  **AI Economy (Token Optimization)**: AIに無駄なデータを読ませてはなりません。**AI-Optimized DTO** でトークンを極限まで節約し、推論精度を高めてください。
*   **DTO設計規約**:
    *   **Strict Segregation**: 機密性の高いフィールドを含むDTOは `AdminDTO` / `PublicDTO` のように型レベルで物理的に分離してください。
    *   **No Raw Return**: Server ActionsやAPIは生のDB型を返してはなりません。必ずDTO型を返してください。
    *   **No Blind Spread**: `...user` のようなスプレッド構文でのプロパティコピーは、将来追加される機密カラムを意図せず漏洩させるためDTO変換層では**完全禁止**です。
    *   **明示的なフィールド選択パターン**: `SELECT *` や `.select('*')` を禁止します。必要なカラムのみを明示的に列挙してください。
*   **DTO同期義務**: BackendのDTOを変更した場合、FrontendのProps型も**同時に更新**してください。片方だけの更新は `undefined` 参照によるランタイムエラーの直接原因です。
*   **DTO Boundary Casting**: DB結果からDTOへの変換は、`as any` ではなく明示的なマッピング関数（`toDTO(dbResult): MyDTO`）で各フィールドを個別にマップしてください。
*   **DTO Segregation**: 肥大化した単一の型定義ファイルを禁止します。機能ドメイン単位で分割してください（例: `types/store.ts`, `types/user.ts`）。
*   **Mapper Input Robustness (Postel's Law)**: マッパー関数の入力は寛容に（ORM推論の不完全さを許容）、出力は厳格に（完全なDTO型を保証）してください。
*   **Explicit Mapping Mandate**: Service層での書き込みペイロード構築にスプレッド構文（`...input`）を**禁止**します。全フィールドを個別にマッピングしてください。

### 13.2. The Client-Server Boundary Protocol（クライアント・サーバー境界）
*   **Client DB Access Prohibition**: クライアントサイドから `supabase.from()` を直接呼び出すことは禁止します。データ取得・更新は必ず `Server Actions` または `Route Handler` を経由してください。
*   **Secure Write Action Protocol (Turnstile Mandate)**: 公開フォームへの書き込みを行う Server Action は、必ず `turnstileToken` を引数として受け取り、サーバーサイドで検証してください。
*   **Service Pattern Mandate**: `page.tsx` や `layout.tsx` 内でDBアクセス関数を直接呼び出すことを禁止します。必ず `lib/api/gateways/` (Read) または `lib/actions/` (Write) にロジックを抽出してください。
*   **Async Boundary Protocol**: Client Component から非同期 Server Component を直接インポートして使用することは React の仕様違反です。必ず `children` Prop またはCompositionパターンを使用してください。

### 13.3. The Service Layer Architecture（サービス層アーキテクチャ）
*   **Service Layer Extraction Mandate**: Route Handler、Server Action等のエントリーポイントは「薄いインターフェース」に徹しなければなりません。ビジネスロジックをエントリーポイントに直書きすることを禁止します。
*   **Thin Controller Mandate**: Controller内のコードは以下に限定します: (a) リクエストのパース・バリデーション、(b) 認証/認可チェック、(c) Service層の呼び出し、(d) レスポンスの構築。Controller内での直接的なDB呼び出しは禁止です。
*   **Service Aggregation Protocol**: 複数のGateway/Actionを統合して1画面分のデータを生成する「集約ロジック」は、必ずService層に `get...Data()` 形式で抽出してください。
*   **Omnichannel Delivery Mandate**: UIコンポーネントにビジネスロジックやデータアクセスを直接記述することを禁止します。全てのロジックはService/Gateway層に抽出し、Web、モバイル、AIエージェントから再利用可能にしてください。
*   **Error Translation**: Service層から発生した例外は、Controller層でHTTPステータスコードに変換してください。Service層がHTTPを知っていてはなりません。

### 13.4. The CQRS & Cache Strategy（CQRS & キャッシュ戦略）
*   **CQRS Separation Mandate**: Read操作（参照）とWrite操作（更新）のロジックを同一の関数に混在させることを禁止します。`QueryGateway` と `CommandGateway` を明確に分離してください。
*   **No Side Effects in Queries**: Query系のメソッドは読み取りと変換のみ。DBへの書き込みや外部API呼び出し等の副作用を一切持ってはなりません。
*   **Hierarchical Cache Strategy**: データ特性を無視した一律のキャッシュ戦略を禁止します。以下のティアに分類してください:
    *   **STATIC** (変更なし): CDN/ISR。**WARM** (日次〜週次変更): TTL 5分〜1時間 + SWR。**HOT** (分単位変更): 短TTL + オンデマンドリバリデーション。**REALTIME** (即時反映): キャッシュ無効 + WebSocket/SSE。
*   **Cache Invalidation Ceremony**: コアクエリロジックを変更した場合は、ビルドキャッシュの物理削除と開発サーバーの完全再起動を義務付けます。
*   **Cache Hit Rate**: キャッシュヒット率を計測し、90%未満のエンドポイントは最適化対象としてください。

### 13.5. The Mutation Integrity Protocol（ミューテーション整合性）
*   **Law**: データ書き込み操作において、`error: null` は成功を意味しません。影響行数（`count`）を常に検証し、0行の場合は明示的にエラーをスローしてください。
*   **Count Validation**: ID指定の単一レコード操作では、影響行数が期待値であることを必ず検証してください。`error: null` かつ `count: 0` は「Phantom Success（偽の成功）」です。
*   **Sub-Step Integrity**: 単一のService関数内で複数の書き込み操作を行う場合、全てのサブステップで `error` と `count` を個別に検証してください。途中のステップが失敗しても最終結果が「成功」を返す「Partial Phantom Success」を防いでください。
*   **Fail-Fast Cascade**: いずれかのステップでエラーが検出された場合、後続ステップを実行せず即座にエラーを返却してください。
*   **Post-Mutation Verification Fetch**: 重要度の高い更新の直後に同一IDで再取得（SELECT）を実行し、データが永続化されたことをログで検証してください。これにより「DB書き込み失敗」と「キャッシュの問題」を100%切り分けられます。
*   **Step-by-Step Logging**: 各サブステップの実行結果をログに出力し（例: `Logger.info('[Step 2/5] Updating tags...')`）、障害発生時の原因特定を迅速化してください。
*   **RLS Awareness**: Row Level Securityを使用するデータベースでは、権限不足はエラーではなく「0行に影響」として返されることを常に念頭に置いてください。

### 13.6. The Type Safety & Integrity Protocol（型安全性と誠実性）
*   **Zero `as any` Policy**: `as any` や `as never` を用いて型エラーを黙殺する行為は「バグの埋め込み」です。ESLint `@typescript-eslint/no-explicit-any` を `error` に設定し、CIで物理的にブロックしてください。
*   **Root Cause Resolution**: 型エラーが発生した場合は、キャストではなく「型定義の修正」「DTOの再設計」「ジェネリクスの適用」で**根本原因**を解消してください。
*   **Type Bridge Mandate**: 自動生成型に不足がある場合は、`database-extensions.ts` に拡張型を定義し、Mapped Typeで型衝突を防いでください。
*   **Linter Suppression Prohibition**: `eslint-disable` / `@ts-ignore` 等の使用は原則禁止です。やむを得ず使用する場合は、理由を明記したコメントとIssue番号を必ず併記してください。
*   **Generic Type Inference Safety**: `Record<string, any>` 等のanyインデックスシグネチャを禁止します。`Record<string, unknown>` または制約付きジェネリクスを使用してください。
*   **Zero Defect Sovereignty**: 型チェック（`tsc --noEmit`）およびLinterが**警告ゼロ**で通過しないコードのコミットを禁止します。

### 13.7. The Error Handling Contract（エラーハンドリング契約）
*   **Structured Error Return**: サーバーアクションは、業務ロジック上の失敗に対して `throw new Error()` を使用することを**原則禁止**します。代わりに `{ success: false, error: '...' }` 形式の構造化されたレスポンスを返してください。
*   **Graceful Failure Contract**: エラー発生時はトースト通知やインラインエラーメッセージとして表示し、ユーザーに適切なフィードバックを提供してください。
*   **Server-Client Symmetry**: サーバーサイドのガード強化を行う際は、必ずフロントエンド側の「エラー受け取り口」を同時に整備してください。
*   **Structured Error Logging**: エラーオブジェクトの文字列テンプレートへの直接埋め込み（`[object Object]` を出力）を禁止します。`message`, `code`, `details` 等のプロパティを明示的に分解してログに記録してください。
*   **Centralized Logging Protocol**: 本番環境での `console.log` を禁止します。必ず `src/lib/logger.ts` を使用してください。
*   **Read-Write Privilege Symmetry**: データの書き込みに特権クライアントを使用している場合、「編集のための読み込み」にも同等の可視性を保証してください。

### 13.8. The Dead Code & Workspace Cleanup（デッドコードとワークスペース清掃）
*   **Dead Code Prohibition**: 現在使用されていないコード（未使用の変数、インポート、関数、型定義）は即時削除を義務付けます。コメントアウトも含めて一切残しません。Git履歴から復元できます。
*   **YAGNI厳格化**: 「将来使うかもしれない」コードは「ノイズ」です。現在のユーザーストーリーに含まれない「先回り実装」は技術的負債です。
*   **Clean Workspace Mandate**: タスク完了時、一時ファイル、ビルドキャッシュ、空ディレクトリ、`console.log` は全て除去してからコミットしてください。
*   **Unstable Timer Protocol**: `setTimeout` や `setInterval` をロジック制御に使用することを禁止します。イベント駆動アーキテクチャまたはジョブキューを使用してください。

### 13.9. The API Product & Configuration（API設計と構成管理）
> **§13.15 Idempotency Key Protocol** も参照してください。
*   **API Product Mindset**: 全てのデータ出力は「商品（Product）」です。APIは必ず **Tier 1 (Public/Free)** と **Tier 2 (Enterprise/Paid)** に分離できる設計にしてください。全Enterprise APIに `recordApiUsage` を計装してください。
*   **API Latency Budget**: 全てのPublic/Enterprise APIのTTIは **200ms以内** に抑えてください。超過する処理は非同期Queueに逃がし、`202 Accepted` を返却してください。
*   **VIP Lane Strategy**: 自社ネイティブアプリからは「Bearer Token認証」と「API Key認証」のOR条件を実装し、ログインユーザーに特権Tierを付与してください。
*   **Tenant-Aware Naming**: 顧客ごとのリソースには `site_` / `account_` を接頭辞として使用し、全テナント共通の基盤設定にのみ `system_` を使用してください。
*   **Legal Hardcoding Ban**: 利用規約等の法的テキストをソースコードに直書きすることは禁止です。管理画面から非エンジニアが即座に修正可能な状態にしてください。
*   **Static Master Protocol**: アプリ全体で使用される定数値は `constants/` に一元定義し、コンポーネント内でのハードコードを禁止します。`as const` でイミュータブルに定義し、`typeof` で型を自動導出してください。
*   **Projection-Schema Parity**: データ取得時の射影仕様はDBスキーマと100%一致しなければなりません。UIやDTOに定義されているがDBに存在しない「幽霊フィールド」を禁止します。

### 13.10. The Authentication & Access Control（認証とアクセス制御）
*   **Audit Bypass Anti-Pattern**: クライアントサイドから直接データベースの書き込みを行うことは、監査ログをバイパスするためガバナンス違反です。全てのデータ更新は必ず Server Actions を経由し、`recordAuditLog` を呼び出してください。
*   **Authentication Guard Enumeration Consistency**: RBACにおいて、許可ロールのリストを複数のガード関数で個別管理することを**禁止**します。全てのガードは共通の定数配列（`ALLOWED_ADMIN_ROLES`）を参照してください。
*   **Dead Zone Detection**: 「画面には入れるが操作だけが失敗する」不透明なデッドロックを防ぐため、ページレベルのガードとアクションレベルのガードが同一のロール集合を参照していることを定期的に監査してください。

### 13.11. The Build & Deploy Verification（ビルドとデプロイ検証）
*   **Production Build Verification**: 開発サーバーが動作していることは、コードの正しさの証明には**なりません**。タスク完了前に以下の **Triple Crown** を必ず通過させてください:
    1.  型チェック（`tsc --noEmit`）: 型エラーゼロ
    2.  リンター（`eslint --max-warnings=0`）: 警告ゼロ
    3.  本番ビルド（`npm run build`）: ビルド成功
*   **CI/CD Environment Gap Protocol**: CI環境は「空のデータベース」でテストを実行するため、既存データとの衝突を検知できません。`INSERT` 文には `ON CONFLICT` を使用し冪等性を確保してください。
*   **Multi-Axis Deployment Audit**: 機能追加・変更時、以下の4軸すべてでグリーンであることを検証してください:
    1.  **Security**: 破壊的アクションに監査ログが計装されているか
    2.  **Structured Data**: 構造化データ（JSON-LD, OpenGraph等）が最新か
    3.  **UX**: エラーメッセージがユーザーの言語で適切に提供されているか
    4.  **Type Safety**: `any` や不透明なキャストが新たに導入されていないか

### 13.12. The Migration & Schema Safety（マイグレーションとスキーマ安全性）
*   **Migration Static Analysis Guard**: マイグレーションファイルのPush/Merge時に、CIパイプラインで**静的解析**を実行し、危険なSQLパターンを物理的に拒否してください。
*   **Forbidden Patterns**: `UPDATE` without `WHERE`、`INSERT` without `ON CONFLICT`、`UNIQUE` constraint without cleanup。
*   **Pre-push Hook**: ローカルでのPush前にスクリプトを実行し、危険なSQLを即座にフィードバックしてください。`--no-verify` でのフック回避は禁止です。
*   **CI Pipeline**: `migration:check` ジョブを常時稼働させ、ヒューマンエラーの最終防衛線としてください。

### 13.13. The Feature Flag Lifecycle Protocol（フィーチャーフラグ運用規律）
*   **Context**: Feature Flagは安全なリリースを可能にしますが、管理されないフラグはコードの複雑性を増大させ、技術的負債となります。
*   **Lifecycle**:
    | フェーズ | 説明 |
    |:--------|:-----|
    | **作成** | フラグ名・目的・期限をドキュメント化 |
    | **有効化** | ステージング環境で検証後、本番に段階展開 |
    | **全展開** | 全ユーザーに展開完了、フラグ削除のカウントダウン開始 |
    | **削除** | フラグ関連コードを全て削除し、クリーンな状態に戻す |
*   **最大存続期間**: **90日**。超過したフラグは技術的負債として記録し、次スプリントで削除を優先してください。
*   **命名規約**: `FF_<FEATURE_NAME>` 形式を推奨します。
*   **Prohibition**: Feature Flagのネスト（入れ子）は認知的複雑性を爆発させるため**禁止**です。
*   **Cleanup Obligation**: フラグを削除した際は、関連する条件分岐コードも**同一PRで**削除してください。
*   **四半期棚卸し義務**: 四半期末にフラグ一覧を棚卸しし、以下のルールを適用してください。
    | 状態 | 日数 | 対応 |
    |:-----|:-----|:-----|
    | ON（全ユーザー展開済み） | > 30日 | フラグを削除し、新機能コードのみ残す |
    | OFF（廃止決定） | > 30日 | フラグとレガシーコードの両方を削除 |
    | 実験中 | > 90日 | 技術的負債として記録、次スプリントで決着 |

### 13.14. The WebAssembly & Edge Execution Protocol（WASM・エッジ実行境界）
> エッジ実行の障害対応については **§15.1 Circuit Breaker** も参照してください。
*   **Context**: WebAssembly (WASM) とエッジコンピューティング（Cloudflare Workers / Deno Deploy / Lambda@Edge等）は、2026年以降のシステムアーキテクチャにおいて不可欠な選択肢です。採用判断は明確な基準に基づかなければなりません。
*   **WASM 3.0 機能の把握（2026年）**:
    *   **WebAssembly 3.0が2026年4月に正式標準化**されました。主な新機能: **WasmGC**（巨大なランタイムを同梱せずにJava・Kotlin・Dart等をターゲット化可能にするGC）、**Memory64**（4GBを超えたメモリアドレス対応—LLM推論・大規模動画処理向け）、**Exception Handling**（効率的なエラー伝達）、**Component Model**（Rust・Go・Pythonなど異なる言語のモジュールが標準化された型共有で連携できるポリグロット相互運用）。
    *   **WASI 0.3 / 1.0**: WASI 0.3（ネイティブ非同期サポート）は2026年前半の重点事項。WASI 1.0は2026年末～2027年初頭の予定で、ファイル・ネットワーク・クロック等システムリソースへのアクセスを標準化し、サーバーサイドWASMのポータビリティを完全実現します。
*   **WASM採用基準**:
    *   **適切なユースケース**: CPU負荷の高い計算（暗号処理・画像変換・音声コーデック・物理シミュレーション）、既存CLIツールのブラウザ移植、言語非依存の共有ロジック（核心ビジネスロジックのRustによる実装）。
    *   **不適切なユースケース**: DOM操作、シンプルなデータ変換、外部APIコール主体の処理 — これらはJavaScript/TypeScriptで十分です。WASMを安易に採用することで起きる複雑性増大は「エンジニアリングの自己満足」であり禁止します。
*   **Edge Execution Mandate**:
    *   **Edge-Eligible Logic**: 認証トークン検証、A/Bテストのバケット振り分け、地理的リダイレクト、CSPヘッダー付与、レート制限のカウンター処理 — これらはエッジで処理することでレイテンシを劇的に削減できます。
    *   **Edge Execution Prohibitions**: データベースへの直接書き込み、長時間実行バッチ処理（エッジはCPU時間制限がある）、ステートフルなセッション管理（ただしEdge KV/Durable Objectsを除く）。
    *   **Cold Start Budget**: エッジ関数のコールドスタートは **50ms以内** を目標とし、これを超える場合はウォームアップ戦略（スケジュールpingなど）を実装してください。
*   **WASM Security Constraints**:
    *   WASMモジュールは必ずContent Security Policy (CSP) の `wasm-unsafe-eval` ディレクティブを意識した設計にしてください。
    *   信頼できないソースから取得したWASMバイナリの実行は**絶対禁止**です。SRI (Subresource Integrity) による整合性検証を義務付けます。

### 13.15. The Idempotency Key Protocol（べき等性キー義務化）
*   **Context**: ネットワーク障害・タイムアウトによるリトライは、料金二重請求・二重注文などの「恐怖の副作用」を引き起こします。べき等性（Idempotency）の設計は、分散システムの基本義務です。
*   **Mandate**:
    *   **変更系API（POST/PUT/DELETE）**: クライアントは全リクエストに `Idempotency-Key: <UUID v4>` ヘッダーを付与してください。
    *   **サーバーサイド**: 受け取ったキーに基づき、同一リクエストの二重処理を防ぐキャッシュ層（Redis / KVストア）を実装してください。
    *   **TTL**: Idempotencyキャッシュの有効期限は **24時間** を標準とします。
    ```typescript
    // サーバーサイドべき等性チェックの実装パターン
    async function processPayment(idempotencyKey: string, payload: PaymentPayload) {
      const cached = await redis.get(`idem:${idempotencyKey}`);
      if (cached) return JSON.parse(cached); // キャッシュヒット: 前回結果を返却
      
      const result = await executePayment(payload);
      await redis.set(`idem:${idempotencyKey}`, JSON.stringify(result), 'EX', 86400);
      return result;
    }
    ```
*   **Saga Pattern for Long Transactions**: 複数サービスにまたがる長期トランザクション（決済→在庫→発送）は、2PCの代わりに**Sagaパターン**（Choreography または Orchestration）を採用してください。各ステップは必ず「補償トランザクション（Compensating Transaction）」を定義してください。

---

## Part XIV: プラットフォームエンジニアリング (Platform Engineering)

> [!NOTE]
> Platform Engineeringは「開発者体験（DX）を製品として設計する」思想です。インフラチームが「インフラを管理する」から「Internal Developer Platform (IDP)を提供する」へと役割が進化します。詳細実装は `operations/400_site_reliability.md` を参照してください。

### 14.1. Internal Developer Platform (IDP) Mandate
*   **Law**: プラットフォームエンジニアリングの目標は、アプリケーション開発者が**セルフサービスで**インフラのプロビジョニング・デプロイ・可観測性アクセスを完結できる環境（IDP）を構築することです。「インフラチームへのチケット起票」という工程の撲滅を目指してください。
*   **Golden Path Mandate**:
    *   **Definition**: Golden Pathとは「新機能を追加する際の、最も安全で最も速い標準的な道筋」です。プロジェクト内に常に定義・維持されていなければなりません。
    *   **Golden Path Components**: プロジェクトテンプレート（スキャフォールディング）、CI/CDテンプレート（`.github/workflows/`の再利用可能ワークフロー）、インフラテンプレート（IaCモジュール）、標準的なObservabilityセットアップ。
    *   **Paved Road vs. Off-Road**: Golden Pathから外れる（off-road）場合は、プラットフォームチームへの必須相談プロセスを設けてください。off-roadが常態化するならGolden Pathの設計不良を疑ってください。
*   **Developer Portal**: Backstage等の開発者ポータルを介して、サービスカタログ・TechDocsへのアクセス・テンプレートギャラリー・コスト/メトリクスダッシュボードをセルフサービス提供することを長期目標としてください。

### 14.2. Infrastructure as Code (IaC) Mandate
*   **Law**: クラウドリソースの**手動作成・手動変更は絶対禁止**です。全てのインフラはIaC（Terraform / Pulumi / CDK等）で定義し、Gitで管理してください。「コンソールで作成したリソース」はドリフトの温床であり、即時IaC化が必要です。
*   **IaC品質基準**:
    *   **モジュール化**: IaCコードは再利用可能なモジュールに分割し、DRY原則を遵守してください。
    *   **State管理**: Terraform Stateはリモートバックエンド（S3 + DynamoDB Lock / GCS + CloudSQL等）で管理し、ローカルstateファイルのGitコミットを**絶対禁止**とします。
    *   **Plan-before-Apply**: CI/CDパイプラインで `terraform plan` の実行と結果のPRコメントへの自動投稿を義務付けます。`apply` は人間の承認後のみ実行してください。
    *   **Cost Estimation in CI**: Infracost等を使用し、PRごとにIaC変更によるコスト増減を自動見積もりしてください。月次コスト増加が **+20%** を超える変更は、FinOps担当者の明示的な承認を必須とします。
        ```hcl
        # Terraform: 必須タグを強制するポリシー例（OPA / Sentinel）
        # 全リソースに environment, team, cost-center の3タグを義務付ける
        required_tags = ["environment", "team", "cost-center"]
        ```

### 14.3. Observability First Protocol（可観測性ファースト原則）
*   **Law**: 可観測性（Observability）はコードが書かれた**後**に追加するものではなく、設計の**一部**です。新機能の定義完了条件には「計装（Instrumentation）の実装」を必須要件として含めてください。
*   **Three Pillars（三本柱の義務化）**:
    *   **Logs（ログ）**: 全てのサービスは構造化ログ（JSON形式）で出力しなければなりません。`console.log` の本番使用は禁止（§13.7参照）。
    *   **Metrics（メトリクス）**: 全てのAPIエンドポイントは `request_count`, `error_rate`, `latency_p99` の3指標を最低限エクスポートしてください。
    *   **Traces（トレース）**: マイクロサービス間・非同期処理間の相関を追うため、分散トレーシング（OpenTelemetry）を全てのサービスで有効化してください。
    *   **Profiles（プロファイル）**: **Continuous Profiling（継続的プロファイリング）** を本番環境で有効化し、CPU・メモリホットスポットをリアルタイムに特定してください。これはObservabilityの第4の柱です。推奨ツール: Pyroscope / Parca / Google Cloud Profiler。
        ```typescript
        // Pyroscope 連携例（Node.js）
        import Pyroscope from '@pyroscope/nodejs';
        Pyroscope.init({
          serverAddress: process.env.PYROSCOPE_SERVER_URL!,
          appName: 'api-server',
          tags: { environment: process.env.NODE_ENV!, version: process.env.APP_VERSION! },
        });
        Pyroscope.start();
        ```
*   **OpenTelemetry Standardization**: ベンダーロックインを避けるため、計装はOpenTelemetry SDK標準を使用してください。特定ベンダーSDK（Datadog SDK, New Relic SDK等）への直接依存は避け、OTelレイヤーを経由させてください。
    ```typescript
    // OpenTelemetry計装の標準例
    import { trace, metrics } from '@opentelemetry/api';
    const tracer = trace.getTracer('service-name', '1.0.0');
    const span = tracer.startSpan('operation.name');
    try {
      // ... business logic
    } finally {
      span.end();
    }
    ```
*   **GenAI Semantic Conventions（2026年必須）**: LLM統合サービスでは、OpenTelemetry GenAI SIGが確立した**OTel GenAI Semantic Conventions**を用いてテレメトリを計装してください。ベンダー別実装なしに複数LLMプロバイダー（OpenAI・Anthropic・Gemini等）間で一貫したテレメトリスキーマを保証できます。
    *   **必須AIテレメトリ属性**: LLM呼び出しごとに `gen_ai.system`, `gen_ai.model.id`, `gen_ai.usage.input_tokens`, `gen_ai.usage.output_tokens` およびレイテンシを取得してください。モデル別コスト帰属とクォータ管理が可能になります。
    *   **エージェントチェーントレーシング**: 多ステップAIエージェントフローにおいては、ツール呼び出し・LLM引数・中間出力を含む全推論チェーンを単一トレース内の子スパンとして記録し、エージェント障害の原因特定を可能にしてください。
    *   **AI専用メトリクス**: `gen_ai.client.token.usage`, `gen_ai.client.operation.duration`, ハルシネーション率・エラー率をインフラメトリクスと並行してエクスポートしてください。
*   **OTel Arrow プロトコル**: 大量テレメトリ環境では、**OTel Arrow**ワイヤプロトコル（標準OTLP比最大80%帯域幅削減）を採用してください。OTel Collectorレイヤーで実装することで、アプリケーションコード変更なしにオブザーバビリティコストを削減できます。
*   **eBPFオート計装（ゼロコードアプローチ）**: 再コンパイルが困難なサービスには、**Beyla**（eBPFベースのゼロコード計装）を検討してください。Beylaはアプリケーションコードを改変せずにHTTP・gRPC・DB呼び出しをカーネルレイヤーで捕捉し、レガシー・サードパーティサービスに最適です。
*   **SLO as Code**: SLI/SLOをコードで定義し（OpenSLO / Sloth等）、Gitで管理してください。「SLOの口頭定義」はドキュメント借金です。詳細は `operations/400_site_reliability.md` を参照してください。
*   **Error Budget Policy（エラーバジェット消費管理）**:
    *   **Error Budget**: `Error Budget = (1 - SLO) × 期間`。例: SLO 99.9% × 30日 = 43.2分のError Budget。
    *   **消費速度アラート**: Error Budgetの消費が以下の閾値を超えた場合、自動アラートを発報してください。
        | 消費率 | 対応アクション |
        |:------|:-------------|
        | 50%消費（月10日以内） | 開発チームへの通知・原因の調査開始 |
        | 75%消費 | 新機能リリースの凍結・信頼性改善を最優先化 |
        | 100%消費（Burndown） | 全リリース停止・SREチームとのPost-Morterm実施必須 |
    *   **Burn Rate Alert**: Prometheus/Grafana等で `burn_rate > 14.4x` を5分ウィンドウで検知するアラートルールを設置してください（Fast Burn Detection）。
*   **Alert Fatigue Prevention（アラート疲労防止）**:
    *   **ルール**: アラートは「実際に人間が対応しなければならない事象のみ」に限定。「分かっているが対応しないアラート」はノイズであり、疲労を招くため、30日以上「対応不要」のアラートは削除または自動抑制を義務付けます。
    *   **アラート設計4原則**:
        1.  **Actionable（実行可能）**: アラート発報時に「次に何をすべきか」が明確であること
        2.  **Meaningful（有意義）**: SLOへの影響がある事象のみ（Symptom-based alerting）
        3.  **Priority（優先度付き）**: P1（即時対応）/ P2（1時間以内）/ P3（次営業日）の3段階
        4.  **Deduplicated（重複除外）**: 根本原因1つに対してアラート1つ（Alert Grouping必須）
    *   **ツール**: PagerDuty / OpsGenie のRouting Ruleで、時間帯・曜日・オンコール輪番を自動管理。深夜3時のP3アラートはOn-callを叩き起こさないよう設定してください。

### 14.4. Event-Driven Architecture Fundamentals（EDA基本原則）
*   **Context**: 非同期イベント駆動アーキテクチャ（EDA）は、疎結合なシステムの構築とスケーラビリティの確保において不可欠です。2026年以降、サービス間通信のデファクトスタンダードとなっています。
*   **When to Use EDA**:
    *   **適切**: サービス間の非同期通知（注文完了メール、ポイント付与）、ユーザーアクションの非同期記録（監査ログ）、サービス間の疎結合が必要な統合、バックプレッシャーが必要なワークロード。
    *   **不適切**: 即時レスポンスが必要なユーザーリクエスト（リクエスト-レスポンスパターンを使用）、単純な同期操作。
*   **EDA設計原則**:
    *   **冪等性（Idempotency）**: 全てのイベントコンシューマーは、同一イベントが複数回配信された場合でも安全に処理できる冪等な実装にしてください。`message_id` によるデデュープロジックを実装してください。
    *   **イベントスキーマ管理**: イベントスキーマはSchema Registryで一元管理し、後方互換性のない変更時は新バージョンのスキーマを定義してください。スキーマの破壊的変更は**禁止**です。
    *   **Dead Letter Queue (DLQ)**: 全てのメッセージキューには必ずDLQを設定し、処理失敗イベントを捕捉してください。DLQのアラートを設定し、放置を禁じます。
    *   **イベントのバージョニング**: イベントには必ず `eventType`, `eventVersion`, `timestamp`, `correlationId` を含めてください。
        ```json
        {
          "eventType": "order.completed",
          "eventVersion": "1.0",
          "timestamp": "2026-04-20T01:00:00Z",
          "correlationId": "req-abc123",
          "payload": { ... }
        }
        ```

### 14.5. Multi-Tenancy Architecture Protocol（マルチテナンシー基本原則）
*   **Context**: SaaSプロダクトにおいて、複数の顧客（テナント）を単一システムで安全に運用するマルチテナンシーは、設計の初期段階から織り込まなければなりません。後付けのマルチテナント化は最大級の技術的負債です。
*   **テナント分離モデルの選択**:
    | モデル | 分離レベル | コスト | 適合シーン |
    |:------|:--------|:------|:---------|
    | **Silo（サイロ）** | 完全（DBもインフラも分離） | 高 | 規制産業・高セキュリティ要件 |
    | **Bridge（ブリッジ）** | 中（DB分離・インフラ共有） | 中 | 中規模SaaS・データ主権要件 |
    | **Pool（プール）** | 低（DB・インフラ共有） | 低 | スタートアップ・コスト優先 |
*   **必須設計原則**:
    *   **Tenant Context Propagation**: 全てのリクエスト処理において、テナントIDを認証トークンから抽出し、サービス層・DB層まで貫通させてください。`context.tenantId` の欠落は**システム最大の脆弱性**です。
    *   **Row Level Security（RLS）**: Poolモデルを採用する場合、DBレイヤーでRLSを有効化し、テナント間のデータ漏洩を物理的に防止してください（詳細は `engineering/200_supabase_architecture.md` 参照）。
    *   **Cross-Tenant Leak Test**: テスト戦略に「クロステナントリーク検証」を必ず含めてください。テナントAの認証情報でテナントBのデータにアクセスできないことをE2Eテストで検証してください。
    *   **Noisy Neighbor Protection**: 特定テナントの高負荷が他テナントに影響しないよう、リクエスト/クエリレベルでのRate Limitをテナント単位で適用してください。

### 14.6. Contract Testing Protocol（コントラクトテスト基本原則）
*   **Context**: マイクロサービスやフロントエンド/バックエンドの分離開発において、APIコントラクト（インターフェース仕様）の不整合は「本番環境でのみ発覚する結合エラー」の主因です。Consumer-Driven Contract Testing（CDCT）によりこれを事前に防ぎます。
*   **CDCT Mandate**:
    *   **Consumer Defines the Contract**: APIを呼び出す側（Consumer）が「自分に必要なフィールドと型」をコントラクトファイルとして定義してください。Pact / Spring Cloud Contract等を使用します。
    *   **Provider Must Verify**: APIを提供する側（Provider）は、全コンシューマーコントラクトに対するProviderテストをCIで実行し、**コントラクト違反のデプロイを物理的にブロック**してください。
    *   **Schema-First for Internal APIs**: 内部API（BFF / マイクロサービス間）はOpenAPI 3.1スキーマから型を自動生成し、実装とスキーマの乖離をゼロにしてください。
*   **Contract Versioning**: コントラクトに破壊的変更を加える場合、「Expand-Contract Pattern」（まず新フィールドを追加、全Consumerが移行後に旧フィールドを削除）を必ず採用してください。

---

## Part XV: レジリエンスエンジニアリング (Resilience Engineering)

> [!IMPORTANT]
> レジリエンスとは「障害を防ぐこと」ではなく「障害に耐え、自己回復すること」です。あらゆる外部依存は必ず失敗します。その前提で設計してください。

### 15.1. Circuit Breaker Protocol（サーキットブレーカー）
*   **Law**: 外部APIやDBへの呼び出しには、必ずサーキットブレーカーパターンを実装してください。フォールバックなしの「直接呼び出し」は、連鎖障害（Cascading Failure）を引き起こす設計上の欠陥です。
*   **State Machine**:
    | 状態 | 説明 | 遷移条件 |
    |:----|:----|:--------|
    | **CLOSED** | 正常稼働。全リクエストを通す | エラー率が閾値超過 → OPEN |
    | **OPEN** | 遮断中。全リクエストを即時失敗させFallbackを返す | タイムアウト後 → HALF_OPEN |
    | **HALF_OPEN** | 試験的に1リクエストを通す | 成功 → CLOSED / 失敗 → OPEN |
*   **設定基準**:
    *   **Error Rate Threshold**: 直近60秒で**50%**超 → OPEN
    *   **Slow Call Threshold**: **2秒**超のレスポンスは「エラー」として計上
    *   **Open Duration**: OPEN状態は最低**30秒**維持（デフォルト）
*   **Fallback Obligation**: OPEN状態では、必ず意味のあるFallbackを返してください。エラーをそのままユーザーに露出させることは禁止です。
    ```typescript
    // サーキットブレーカーの実装例（cockatiel / opossum ライブラリ）
    import { wrap } from 'cockatiel';
    const circuitBreaker = wrap(
      timeout(callExternalApi, { milliseconds: 2000 }),
      CircuitBreakerPolicy.builder()
        .handle(HttpError).orResultType((r) => r.status >= 500)
        .build()
    );
    const result = await circuitBreaker.execute(ctx).catch(() => fallbackData);
    ```

### 15.2. Retry & Exponential Backoff Protocol（リトライ戦略）
*   **Law**: 失敗したリクエストを即座に再試行してはなりません。指数バックオフ（Exponential Backoff）とジッター（Jitter）を組み合わせて自然な分散を実現してください。
*   **Retry Policy**:
    *   **Max Retries**: **3回**（デフォルト）。冪等でないリクエストはリトライ禁止。
    *   **Base Delay**: 初回リトライは **1秒** 待機。以降は `min(base * 2^attempt, maxDelay)` で増加。
    *   **Max Delay**: **30秒**（上限キャップ）
    *   **Jitter**: `delay × random(0.5, 1.5)` でサンダリングハード問題を防止
    ```typescript
    // Exponential Backoff + Jitter の実装
    async function withRetry<T>(fn: () => Promise<T>, maxRetries = 3): Promise<T> {
      for (let attempt = 0; attempt <= maxRetries; attempt++) {
        try {
          return await fn();
        } catch (err) {
          if (attempt === maxRetries) throw err;
          const base = Math.min(1000 * 2 ** attempt, 30_000);
          const jittered = base * (0.5 + Math.random() * 1.0);
          await new Promise(r => setTimeout(r, jittered));
        }
      }
      throw new Error('Unreachable');
    }
    ```
*   **Idempotency First**: リトライ可能なのは**べき等なリクエストのみ**です。非べき等な操作（支払い処理等）は §13.15 のIdempotency Keyで制御してください。

### 15.3. Bulkhead Pattern（バルクヘッドパターン）
*   **Context**: 船の隔壁（Bulkhead）のように、システムの異なるコンポーネントを分離し、一部の障害がシステム全体を停止させないようにします。
*   **Mandate**:
    *   **Connection Pool Isolation**: 重要度の異なるサービス（ユーザー向けAPI / 管理画面 / バッチ処理）には、**個別のDB接続プールを割り当て**てください。バッチ処理がユーザー向けAPIのコネクションを枯渇させてはなりません。
    *   **Thread Pool Isolation**: 外部API呼び出しに対してセマフォ（Semaphore）を設定し、同時実行数を制限してください。デフォルトの同時実行上限: **10**。
    *   **Service Quota Separation**: テナント単位でのRate Limitを §14.5 と組み合わせて実装し、Noisy Neighbor問題を防止してください。

### 15.4. Health Check & Readiness Protocol（ヘルスチェック基準）
*   **Law**: 全てのサービスは、Kubernetes / load balancer が判断するための適切なヘルスチェックエンドポイントを必ず提供してください。
*   **Endpoint Standards**:
    | エンドポイント | 用途 | ステータスコード |
    |:------------|:----|:--------------|
    | `GET /health/live` | Liveness: プロセスが生きているか | 200 / 503 |
    | `GET /health/ready` | Readiness: トラフィックを受け付けられるか（DB接続確認含む） | 200 / 503 |
    | `GET /health/startup` | StartupProbe: 初期化完了確認（重実装向け） | 200 / 503 |
*   **Readiness Check Requirements**: `/ready` エンドポイントは以下を全て確認してください:
    1.  DBへの接続確認（`SELECT 1` クエリ実行）
    2.  主要キャッシュサービス（Redis等）の接続確認
    3.  必須環境変数の存在確認
*   **Response Time Budget**: ヘルスチェックは **500ms以内** に返却してください。超過する場合は自動でタイムアウトし `503` を返却してください。
*   **No Business Logic**: ヘルスチェックエンドポイントにビジネスロジックを入れることを禁止します。副作用ゼロの状態確認のみです。

### 15.5. Graceful Shutdown Protocol（グレースフルシャットダウン）
*   **Law**: プロセス終了シグナル（SIGTERM）受信時に、進行中のリクエストを完了させてから終了する「グレースフルシャットダウン」を全てのサービスに実装してください。
*   **Shutdown Sequence**:
    1.  `SIGTERM` 受信 → 新規リクエストの受け付けを停止（Readinessを `503` に変更）
    2.  進行中のリクエストの完了を待機（最大 **30秒**）
    3.  DB接続・キャッシュ接続のクリーンクローズ
    4.  プロセス終了
*   **K8s terminationGracePeriodSeconds**: Kubernetesでは `terminationGracePeriodSeconds: 60` を設定し、上記のシャットダウン手順が完了するための十分な時間を確保してください。
*   **In-Flight Request Guard**: プロセス終了時に処理中だったリクエストは、クライアントが自動リトライできるよう `Connection: close` ヘッダーを返却してください。

---

## Part XVI: 開発者体験ガバナンス (Developer Experience Governance)

> [!NOTE]
> 優れたDXは「エンジニアの幸福度」ではなく「ビジネス速度」の問題です。開発環境の標準化とオンボーディングの最適化は、組織の最速の競争優位となります。

### 16.1. Local Development Environment Standardization（ローカル環境標準化）
*   **Law**: 「私のマシンでは動く（Works on My Machine）」問題を物理的に排除することを義務とします。環境の再現性を保証する仕組みを必ず実装してください。
*   **Dev Container Mandate**:
    *   **方法A（推奨）**: `.devcontainer/devcontainer.json` を使用したDev Containers (VS Code / GitHub Codespaces)。チームは同一のOSとツールチェーンで開発します。
    *   **方法B**: `flake.nix` を使用したNix Flakesによる再現可能な開発環境（macOS/Linux共通）。
    *   どちらかを**プロジェクト開始時に決定し、README.mdに記載**してください。選択肢の混在は禁止です。
*   **First-Day Productivity Target（初日生産性目標）**: 新規参画者が、環境構築からローカル開発サーバー起動まで **30分以内** に完了できることを目標とし、計測してください。超過する場合はオンボーディングドキュメントの改善を義務付けます。
*   **Seed Data Protocol**: `npm run seed` または同等のコマンドで、開発に必要なダミーデータが**1コマンドで**生成できる体制を維持してください。開発者が手動でデータを作成する必要がある状態は「DXの失敗」です。

### 16.2. Cognitive Load Reduction Protocol（認知的負荷低減）
*   **Context**: エンジニアの生産性を最も阻害するのは「コードの複雑さ」ではなく「コードを理解するための認知的コスト」です。
*   **Complexity Budgets（複雑度予算）**:
    *   **ファイル行数**: 1ファイル **300行以下**（§5.4参照）
    *   **関数行数**: 1関数 **50行以下**。超過する関数は分割を義務付けます。
    *   **引数の個数**: 関数引数は **4個以下**。超過する場合はオブジェクト引数（パラメータオブジェクトパターン）に変換してください。
    *   **Cyclomatic Complexity**: 関数の循環的複雑度は **10以下**を必須とします。ESLintの `complexity` ルールで自動計測してください。
*   **Abstraction Level Consistency**: 関数内の抽象レベルを一定に保ってください。「SQLクエリの詳細」と「ビジネスルールの日本語表現」が同一関数内に混在することを禁止します。
*   **The Naming Investment Rule**: 変数・関数名の命名に「5分思考」を義務付けます。`data`, `result`, `val`, `tmp` 等の無意味な名前は否認してください。

### 16.3. Onboarding SLO & Knowledge Transfer Protocol（オンボーディングとナレッジ移転）
*   **Onboarding SLO（サービスレベル目標）**:
    | マイルストーン | 目標期間 |
    |:------------|:--------|
    | ローカル環境構築完了 | 入社1日目 終業まで |
    | 最初のPRのマージ | 入社3日目まで |
    | 独立したタスクの開始 | 入社2週間目まで |
*   **Buddy System Mandate（バディ制度の義務化）**: 新規参画者には必ず1名のオンボーディングバディを割り当ててください。バディは最初の2週間、毎日15分の1on1を実施する義務を負います。
*   **Architecture Decision Record (ADR) Mandate**:
    *   重要な技術的意思決定（フレームワーク選定・DB設計・外部API選定等）は、`docs/adr/NNNN-{title}.md` にADRとして記録することを義務付けます。
    *   **ADR Format**: `## Status`, `## Context`, `## Decision`, `## Consequences` の4セクション必須。
    *   ADRは「なぜその決定をしたか」を後任エンジニアが理解できる唯一の資産です。記録のないアーキテクチャ判断は**組織の知的財産の損失**です。
*   **Single Person Knowledge Ban（属人化防止）**: 特定の機能・システムについて「あの人しか知らない」状態は最大のリスクです。全てのコアコンポーネントに対して、最低**2名以上**がオーナーシップを持つように設計してください（CODEOWNERS §12.9参照）。

### 16.4. エンジニアリングメトリクス & DORAプロトコル (Engineering Metrics & DORA)
*   **Context**: 「計測できないものは改善できない（Peter Drucker）」。エンジニアリングの健全性を客観的に把握するため、DORA（DevOps Research and Assessment）のメトリクスとSPACEフレームワークを採用してください。DORA調査は2025-2026年にかけて大きく進化しました：従来の4指標が5指標に拡張され、パフォーマンスの「ティア（階層）」評価がアーキタイプ分析に置き換えられ、AI計測が一等市民として追加されました。
*   **DORA 5大メトリクス（必須計測）**:

> [!NOTE]
> 従来の「Low/Medium/High/Elite」4段階ティア評価は、DORA 2025-2026調査で廃止されました。現在はパフォーマンス分布に基づく**7つのチームアーキタイプ**を用いて分析します。固定ベンチマーク到達より「自組織内での継続的改善」に焦点を当ててください。

    | メトリクス | 定義 | 分類 |
    |:----------|:----|:----|
    | **Deployment Frequency（デプロイ頻度）** | プロダクションへのデプロイ頻度 | スループット |
    | **Lead Time for Changes（変更リードタイム）** | コードコミットからプロダクション反映までの時間 | スループット |
    | **Failed Deployment Recovery Time（デプロイ失敗からの復旧時間）** | 失敗したデプロイから復旧までの時間（旧MTTR） | スループット |
    | **Change Failure Rate（変更失敗率）** | デプロイが障害を引き起こす割合 | 安定性 |
    | **Rework Rate（手戻り率）** | 計画外・リアクティブなデプロイの割合 | 安定性 |

*   **参考ベンチマーク（継続改善の目安）**:
    | メトリクス | 目指すべき水準 | 要改善 |
    |:----------|:-------------|:-------|
    | デプロイ頻度 | オンデマンド（1日複数回） | 週1回以下 |
    | 変更リードタイム | 1時間以内 | 1週間以上 |
    | デプロイ失敗からの復旧時間 | 1時間以内 | 1日以上 |
    | 変更失敗率 | 5%以下 | 15%以上 |
    | 手戻り率 | 全デプロイの10%以下 | 30%以上 |
*   **計測の実行義務**:
    *   上記5指標はCI/CDパイプラインから自動収集し、週次ダッシュボードで可視化してください（手動計測は禁止）。
    *   GitHubであれば GitHub Actions Metrics / DORA APIを活用し、DORA指標を自動算出してください。
    *   四半期ごとにチームで振り返り、改善アクションをバックログに積んでください。
*   **AI対応計測（2026年追加）**:
    *   **AI生成コードCFR**: `[AI-Generated]`タグが付いたPRの変更失敗率を独立してトラッキングしてください（§5.3参照）。AI CFRが全体CFRを**+5pp以上**上回った場合、AIコードガバナンスプロセスの見直しを義務付けます。
    *   **Developer Experience Index（DX指数）**: DORA指標と並行してDX指数を計測・報告してください。計測軸はフロー効率性・認知負荷・ツールチェーン摩擦・心理的安全性です。DX Core 4やHaystack Analyticsなどのツールを活用してください。
*   **SPACE フレームワーク（補完的計測）**:
    | 軸 | 計測指標（例） |
    |:--|:------------|
    | **S**atisfaction（満足度） | 開発者NPS、チーム幸福度スコア、DX指数 |
    | **P**erformance（成果） | バグ率、コードレビュー合格率 |
    | **A**ctivity（活動量） | PRマージ数（参考値、KPIにしない） |
    | **C**ommunication（連携度） | PRレビュー応答時間、ドキュメント更新率 |
    | **E**fficiency（効率性） | ビルド時間、テスト実行時間、CI待ち時間 |
*   **アンチパターン禁止**:
    *   個人のコミット数・PR数をパフォーマンス評価に使用することは**禁止**です（Activity指標の誤用）。
    *   メトリクス達成を目的とした「PR分割の水増し」「不必要なデプロイ」は憲法違反です。
    *   固定ティア到達を目標とすることは禁止です。水準そのものより「改善のトレンド」が重要です。

---

## Part XVII: ゼロダウンタイム・スキーマ進化 (Zero-Downtime Schema Evolution)

> [!IMPORTANT]
> DB スキーマの変更は「最もリスクの高いデプロイ」です。ゼロダウンタイムでのスキーマ進化は義務であり、「メンテナンス時間」は2026年以降の本番サービスでは許容されません。

### 17.1. Expand-Contract パターン（非破壊マイグレーション）
*   **Law**: すべての非後方互換なスキーマ変更（カラム名変更・型変更・カラム削除）は、**Expand-Contract パターン**（別名: Parallel Change）で段階的に実施してください。直接の破壊的変更は**絶対禁止**です。
*   **3フェーズ手順**:
    | フェーズ | 操作 | 説明 |
    |:--------|:-----|:----|
    | **Phase 1: Expand（拡張）** | 新カラムを `DEFAULT NULL` で追加 | 既存コードはそのまま動作する |
    | **Phase 2: Migrate（移行）** | 新旧両方のカラムに書き込むアプリを同時デプロイ | バックフィルバッチで既存データを新カラムにコピー |
    | **Phase 3: Contract（収縮）** | 旧カラムを削除するマイグレーション + アプリから旧参照を削除 | 全トラフィックが新カラムを参照している状態で実施 |
*   **バックフィルの安全基準**:
    *   バックフィルは「バッチ処理 + レート制限」で実施し、本番DBの一括ロックを防いでください。
    *   `BATCH_SIZE`は **1,000行以下** を推奨し、行間に `SLEEP 10ms` を挟んでください。
    ```sql
    -- 安全なバックフィル例（PostgreSQL）
    DO $$
    DECLARE batch_id bigint := 0;
    BEGIN
      LOOP
        UPDATE users SET new_column = old_column
        WHERE id > batch_id AND id <= batch_id + 1000 AND new_column IS NULL;
        batch_id := batch_id + 1000;
        EXIT WHEN NOT FOUND;
        PERFORM pg_sleep(0.01); -- 10ms sleep
      END LOOP;
    END $$;
    ```

### 17.2. ゼロダウンタイム・インデックス作成プロトコル
*   **Law**: テーブルへのインデックス追加は `CREATE INDEX CONCURRENTLY` を必須とします。`CREATE INDEX`（非CONCURRENT）は長時間のテーブルロックを取得し、本番停止を引き起こします。
*   **実装基準**:
    *   PostgreSQL: `CREATE INDEX CONCURRENTLY idx_name ON table(column);`
    *   MySQL: `ALTER TABLE ... ADD INDEX` はデフォルトでオンライン実行。ただし大テーブルは `pt-online-schema-change` を使用してください。
    *   **モニタリング義務**: インデックス作成中は `pg_stat_progress_create_index`（PostgreSQL）でブロッキング状態を監視してください。
*   **インデックス削除**: 未使用インデックスはクエリパフォーマンスを低下させます。`pg_stat_user_indexes` で `idx_scan = 0` のインデックスを四半期ごとに審査し、削除候補をバックログに積んでください。

### 17.3. スキーマバージョニングとドリフト防止
*   **Law**: マイグレーションは「不変の歴史（Immutable History）」です。一度適用したマイグレーションファイルを修正・削除することは**絶対禁止**です。修正が必要な場合は必ず新規マイグレーションファイルを作成してください。
*   **スキーマドリフト検出**:
    *   CI/CDパイプラインにスキーマドリフト検出ステップを必須として追加してください（例: `supabase db diff`, `flyway diff`, `pg_dump | diff`）。
    *   本番DBスキーマとマイグレーション履歴の差異が検出された場合は「Critical Drift Alert」を発報し、即座にエスカレーションしてください。
*   **マイグレーションファイル命名**: `V{YYYYMMDDHHMMSS}__description_snake_case.sql` 形式で統一し、タイムスタンプの重複を防いでください。

### 17.4. 大テーブルへの安全な変更プロトコル
*   **大テーブルの定義**: 行数 **100万行以上** または サイズ **1GB以上** のテーブルは「大テーブル」とみなし、以下の追加プロトコルを適用してください。
*   **追加手順**:
    | 操作 | 推奨手法 |
    |:----|:--------|
    | カラム追加（NOT NULL） | `DEFAULT` 値を指定し `ADD COLUMN … DEFAULT 'value'`（Postgres 11+では瞬時） |
    | カラム削除 | Expand-Contractの3フェーズを必ず経ること |
    | カラム型変更 | 新カラム追加 → バックフィル → 旧カラム削除の3フェーズ |
    | テーブル名変更 | ビュー（View）を使った段階的移行を採用する |
*   **ロック監視**: 変更前後に `pg_locks` / `SHOW PROCESSLIST`（MySQL）でロック状態をリアルタイム監視してください。ロック時間が **5秒** を超えたら計画を中断し、アプローチを見直してください。

### 17.5. マルチサービス間スキーマ変更の調整プロトコル
*   **Context**: マイクロサービス構成またはフロントエンド/バックエンドが分離したシステムでは、DBスキーマ変更時に複数サービスの協調デプロイ順序が重要です。
*   **デプロイ順序の原則**:
    1.  **Phase 1（Expand）**: DBマイグレーションを先にデプロイ（新カラム追加）
    2.  **Phase 2（Migrate）**: 旧/新両対応のアプリ全サービスをローリングデプロイ
    3.  **Phase 3（Contract）**: 全サービスが移行完了後にのみ旧カラム削除マイグレーションを実施
*   **後方互換APIの維持義務**: スキーマ変更に伴うAPIレスポンスの変更は**Expand-Contract Pattern**（§14.6参照）で管理し、Consumer側に同時デプロイを強制してはなりません。

---

## Part XVIII: アクセシビリティ・エンジニアリング (Accessibility Engineering)

> [!IMPORTANT]
> アクセシビリティは「UXの配慮」ではなく「法的・倫理的なエンジニアリング義務」です。EU Accessibility Act（2025年6月施行）・ADA・障害者差別解消法により、アクセシビリティ違反は法的リスクです。デザイン工程だけに委ねず、**エンジニアが実装・CI・テストで担保**してください。

### 18.1. アクセシビリティ優先順位と準拠基準 (Compliance Baseline)
*   **必須準拠基準**: WCAG 2.2 Level AA をすべての新機能リリースの「Definition of Done」の必須条件とします。
*   **対象法令**:
    | 法令 | 適用範囲 | 施行日 / 期限 |
    |:----|:--------|:-------------|
    | EU Accessibility Act (EAA) | EU市場向け製品・サービス | 2025年6月28日 |
    | Americans with Disabilities Act (ADA) | 米国市場（Web/アプリ対象判例確立） | 即時 |
    | EN 301 549 | 欧州公共機関調達 | 即時 |
    | 障害者差別解消法（日本） | 国内サービス | 2024年4月改正・義務化 |
*   **優先順位**: `アクセシビリティ > 開発速度 > 視覚的洗練度`

### 18.2. CI/CD アクセシビリティ自動化プロトコル
*   **Law**: アクセシビリティのチェックを「人手レビューのみ」に依存することは禁止です。CI パイプラインに自動チェックを必須として組み込んでください。
*   **自動化ツールチェーン（三層防御）**:
    | レイヤー | ツール | 実行タイミング | 目的 |
    |:--------|:------|:-------------|:----|
    | **静的解析** | `eslint-plugin-jsx-a11y` | コミット時（pre-commit） | `alt`属性漏れ・`label`不足の早期検出 |
    | **コンポーネントテスト** | `@testing-library/jest-dom` + `jest-axe` | ユニット/統合テスト実行時 | axe-coreルール違反の自動検出 |
    | **E2Eブラウザ監査** | `axe-playwright` / Playwright + `@axe-core/playwright` | PR作成時のCI | 実レンダリング後のViolation検出 |
*   **Violation Gate**: CI において axe-core の `violations.length > 0` はビルドを **物理的にブロック** してください。
    ```typescript
    // jest-axe を使ったコンポーネントa11yテストの例
    import { axe, toHaveNoViolations } from 'jest-axe';
    import { render } from '@testing-library/react';
    expect.extend(toHaveNoViolations);

    test('UserCard はa11y違反がないこと', async () => {
      const { container } = render(<UserCard user={mockUser} />);
      const results = await axe(container);
      expect(results).toHaveNoViolations(); // 違反があればCIブロック
    });
    ```
    ```typescript
    // axe-playwright を使ったE2E a11yチェックの例
    import { checkA11y } from 'axe-playwright';
    test('ログインページ a11y', async ({ page }) => {
      await page.goto('/login');
      await checkA11y(page, undefined, {
        detailedReport: true,
        detailedReportOptions: { html: true },
      });
    });
    ```

### 18.3. セマンティックHTML強制プロトコル
*   **Law**: `div`クリックハンドラや `span` ボタン等の非セマンティック実装は「アクセシビリティの詐欺」です。ESLint `jsx-a11y/interactive-supports-focus` ルールで自動ブロックしてください。
*   **セマンティック実装チェックリスト**:
    | 役割 | 正しい実装 | 禁止実装 |
    |:----|:---------|:--------|
    | ボタン | `<button type="button">` | `<div onClick>` , `<span onClick>` |
    | リンク | `<a href="...">` | `<div onClick={() => router.push(...)}>`  |
    | フォーム入力 | `<label htmlFor>` + `<input id>` | `placeholder` のみで `label` なし |
    | ダイアログ | `<dialog>` または `role="dialog"` + `aria-modal` | 可視性だけで制御する `div` モーダル |
    | ナビゲーション | `<nav aria-label="...">`  | `<div class="nav">` |
    | ページ見出し構造 | `h1`→`h2`→`h3` の階層遵守 | スタイルのために `h1` を複数使用 |

### 18.4. キーボード & フォーカス管理プロトコル
*   **Law**: マウス操作で可能な全操作は、キーボードのみでも完結できなければなりません。これはWCAG 2.1.1（Keyboard）の法的要件です。
*   **実装**:
    *   **Focus Trap**: モーダル・ドロワー・ポップオーバー開放時は、フォーカスをそのコンポーネント内に閉じ込め（Focus Trap）、`Esc` キーで閉じてください。
    *   **Focus Indicator**: CSS で `outline: none` / `outline: 0` を使用することを**禁止**します。フォーカスリングは WCAG 2.4.13（Focus Appearance）に準拠した視覚的に明確なスタイルで表示してください（最低3:1のコントラスト比）。
    *   **Skip Link**: 全ページに `<a href="#main-content" class="sr-only focus:not-sr-only">メインコンテンツへスキップ</a>` を設置してください。
    *   **Tab Order**: `tabindex` の正の値（`tabindex="1"`, `tabindex="2"` 等）の使用を禁止します。DOMの自然な順序でフォーカス順序を制御してください。

### 18.5. カラーコントラスト & 視覚デザイン強制
*   **コントラスト比要件（WCAG 2.2 AA）**:
    | 要素 | 最低コントラスト比 |
    |:----|:-----------------|
    | 通常テキスト（18px未満 / 14px未満 Bold未満） | **4.5 : 1** |
    | 大テキスト（18px以上 または 14px以上 Bold） | **3 : 1** |
    | UIコンポーネント・グラフィック要素 | **3 : 1** |
*   **自動計測**: Storybook + `@storybook/addon-a11y` をコンポーネント開発に導入し、デザイントークン設定時にコントラスト比を自動計測してください。
*   **色覚多様性対応**: 情報の伝達に色のみを使用することを禁止します（WCAG 1.4.1）。エラー状態はアイコン+テキスト+色の組み合わせで表現してください。

### 18.6. インタラクティブコンポーネントのARIA実装基準
*   **ARIA Law（最優先原則）**: 適切なネイティブHTML要素が存在する場合、ARIAの使用より**ネイティブHTML**を優先してください。「ARIAなしで実装できる」ことが最高の実装です（ARIA in HTML仕様）。
*   **ARIA必須実装パターン**:
    | コンポーネント | 必須ARIA属性 |
    |:------------|:-----------|
    | カスタムドロップダウン | `role="combobox"`, `aria-expanded`, `aria-controls`, `aria-activedescendant` |
    | タブ | `role="tablist"`, `role="tab"`, `aria-selected`, `role="tabpanel"`, `aria-labelledby` |
    | モーダル | `role="dialog"`, `aria-modal="true"`, `aria-labelledby` |
    | アコーディオン | `aria-expanded`, `aria-controls`, `aria-labelledby` |
    | 通知・アラート | `role="alert"` (即時通知), `role="status"` (非緊急通知) |
    | ローディング | `aria-busy="true"`, `aria-live="polite"` |
    | 非表示コンテンツ | `aria-hidden="true"` で支援技術から隠す |
*   **動的コンテンツ**: SPA での画面遷移後、新しいページのタイトルをスクリーンリーダーにアナウンスしてください（`aria-live` リージョンまたは `document.title` 更新）。

### 18.7. a11y テスト・監査プロトコル
*   **スクリーンリーダー実機テスト（年2回以上）**:
    | プラットフォーム | スクリーンリーダー | ブラウザ |
    |:--------------|:---------------|:--------|
    | macOS / iOS | VoiceOver | Safari |
    | Windows | NVDA / JAWS | Chrome / Firefox |
    | Android | TalkBack | Chrome |
*   **Manual Audit Protocol**: 四半期に1回、クリティカルパス（ログイン・チェックアウト・主要CRUD）を**キーボードのみ**で操作し、全フローが完結することを確認してください。
*   **Score Target（Lighthouse a11y）**: Lighthouse Accessibility スコア **95点以上** を維持してください（§2.2の90点より高い水準を義務付け）。
*   **Regression Prevention**: アクセシビリティ修正を行った際は、対応するテストを `test('a11y regression: [コンポーネント名]')` 形式で追加し、回帰を防止してください。

---

## Appendix A: 逆引き索引

| キーワード | セクション | 関連ルール |
|-----------|----------|-----------|
| ネーミング / kebab-case | §1.0 | `engineering/300_web_frontend.md`, `engineering/400_mobile_flutter.md` |
| DTO / 型変換 | §13.1, §13.6 | `engineering/300_web_frontend.md` |
| パフォーマンス / LCP / CWV | §2.2 | `engineering/300_web_frontend.md`, `operations/400_site_reliability.md` |
| 接続プール | §2.0 | `engineering/200_supabase_architecture.md`, `operations/400_site_reliability.md` |
| DevSecOps / セキュリティ | §3.0 – §3.9 | `security/000_security_privacy.md`, `security/100_data_governance.md` |
| サプライチェーンセキュリティ | §3.5 | `security/000_security_privacy.md` |
| シークレットローテーション | §3.6 | `security/000_security_privacy.md` |
| OAuth / OIDC / PKCE | §3.7 | `security/000_security_privacy.md` |
| AI/LLM セキュリティ / Prompt Injection | §3.8 | `ai/000_ai_engineering.md`, `security/000_security_privacy.md` |
| **内部不正対策 / Insider Threat** | **§3.9** | `security/000_security_privacy.md` |
| 技術的負債 | §4.0 – §4.4 | `operations/600_cloud_finops.md` |
| AIファースト / コードレビュー | §5.0 – §5.4 | `ai/000_ai_engineering.md` |
| グリーンコーディング / SCI | §6.0 – §6.3 | `operations/600_cloud_finops.md` |
| ゼロバグ・ポリシー | §7.0 – §7.3 | `quality/000_qa_testing.md`, `operations/500_incident_response.md` |
| Testing Trophy / テスト戦略 | §9.3 | `quality/000_qa_testing.md` |
| Property-Based Testing / Chaos / Litmus | §9.4 | `quality/000_qa_testing.md`, `operations/500_incident_response.md` |
| Git / バージョン管理 | §10.0 – §10.6 | `operations/400_site_reliability.md` |
| ドキュメント運用 | §11.0 – §11.2 | `operations/000_internal_tools.md` |
| Feature Flags | §13.13 | `operations/400_site_reliability.md`, `quality/000_qa_testing.md` |
| ミューテーション整合性 | §13.5 | `engineering/300_web_frontend.md` |
| CQRS / キャッシュ | §13.4 | `operations/400_site_reliability.md` |
| 認証 / アクセス制御 | §13.10 | `security/000_security_privacy.md` |
| マイグレーション安全 | §13.12 | `operations/400_site_reliability.md` |
| べき等性 / Idempotency Key | §13.15 | `engineering/300_web_frontend.md`, `operations/400_site_reliability.md` |
| WebAssembly / エッジ実行 | §13.14 | `engineering/300_web_frontend.md`, `operations/400_site_reliability.md` |
| Platform Engineering / IDP | §14.1, §14.2 | `operations/400_site_reliability.md`, `operations/600_cloud_finops.md` |
| 可観測性 / OpenTelemetry | §14.3 | `operations/400_site_reliability.md`, `ai/100_data_analytics.md` |
| Error Budget / Alert Fatigue | §14.3 | `operations/400_site_reliability.md`, `operations/500_incident_response.md` |
| イベント駆動 / EDA | §14.4 | `operations/400_site_reliability.md`, `quality/000_qa_testing.md` |
| マルチテナンシー | §14.5 | `security/000_security_privacy.md`, `engineering/200_supabase_architecture.md` |
| コントラクトテスト | §14.6 | `quality/000_qa_testing.md` |
| Circuit Breaker / Retry | §15.1, §15.2 | `operations/400_site_reliability.md`, `operations/500_incident_response.md` |
| Bulkhead / ヘルスチェック | §15.3, §15.4 | `operations/400_site_reliability.md` |
| Graceful Shutdown | §15.5 | `operations/400_site_reliability.md` |
| ローカル環境標準化 / Dev Container | §16.1 | `operations/000_internal_tools.md` |
| 認知的負荷 / Complexity Budget | §16.2 | `engineering/300_web_frontend.md` |
| オンボーディング / ADR / 属人化防止 | §16.3 | `operations/000_internal_tools.md` |
| DORA / SPACEメトリクス / DevOps計測 | §16.4 | `operations/400_site_reliability.md`, `ai/100_data_analytics.md` |
| スキーマ進化 / Expand-Contract | §17.1 | `engineering/200_supabase_architecture.md`, `operations/400_site_reliability.md` |
| ゼロダウンタイム・インデックス | §17.2 | `engineering/200_supabase_architecture.md` |
| スキーマドリフト防止 | §17.3 | `operations/400_site_reliability.md`, `quality/000_qa_testing.md` |
| 大テーブル変更 / バックフィル | §17.4 | `engineering/200_supabase_architecture.md` |
| マルチサービス・スキーマ調整 | §17.5 | `operations/400_site_reliability.md`, `quality/000_qa_testing.md` |
| アクセシビリティ / WCAG 2.2 AA | §18.1 | `design/000_design_ux.md`, `quality/000_qa_testing.md` |
| axe-core CI / a11yゲート | §18.2 | `quality/000_qa_testing.md`, `engineering/300_web_frontend.md` |
| セマンティックHTML / ARIA | §18.3, §18.6 | `engineering/300_web_frontend.md`, `design/000_design_ux.md` |
| キーボード操作 / フォーカス管理 | §18.4 | `design/000_design_ux.md`, `engineering/300_web_frontend.md` |
| カラーコントラスト / 色覚多様性 | §18.5 | `design/000_design_ux.md` |
| スクリーンリーダーテスト | §18.7 | `quality/000_qa_testing.md` |
| Mutation Testing / Stryker | §9.3 | `quality/000_qa_testing.md` |
| Continuous Profiling / Pyroscope | §14.3 | `operations/400_site_reliability.md`, `ai/100_data_analytics.md` |
| Zero Trust 5原則 / NIST SP 800-207 | §3.0 | `security/000_security_privacy.md` |
| Visual Regression Testing | §9.5 | `quality/000_qa_testing.md`, `engineering/300_web_frontend.md` |
| API Design-First / OpenAPI | §19.1 | `engineering/300_web_frontend.md`, `quality/000_qa_testing.md` |
| データ品質エンジニアリング / dbt | §19.2 | `operations/400_site_reliability.md`, `ai/100_data_analytics.md` |
| FinOps ユニットエコノミクス | §19.3 | `operations/600_cloud_finops.md` |
| Blameless文化 / ポストインシデント | §19.4 | `operations/500_incident_response.md` |
| Secrets Governance / CVE SLA | §19.5 | `security/000_security_privacy.md` |
| VEX / CSPM / SBOM | §19.5 | `security/000_security_privacy.md` |
| 自動リリース / semantic-release | §19.6 | `operations/400_site_reliability.md` |
| **AIエージェント・セキュリティ** | **§20.1** | `ai/000_ai_engineering.md`, `security/000_security_privacy.md` |
| **MCP セキュリティ基準** | **§20.2** | `ai/000_ai_engineering.md` |
| **マルチエージェント認可モデル** | **§20.3** | `ai/000_ai_engineering.md`, `security/000_security_privacy.md` |
| **エージェント・ハルシネーション管理** | **§20.4** | `ai/000_ai_engineering.md`, `quality/000_qa_testing.md` |
| **AIエージェント コスト制御** | **§20.5** | `operations/600_cloud_finops.md`, `ai/000_ai_engineering.md` |

---

## Part XIX: 先進エンジニアリング実践 (Advanced Engineering Practices)

> [!NOTE]

### 19.1. API Design-First Protocol（API設計先行原則）
*   **Context**: API実装を先に書き、後からドキュメント化する「コードファースト（Code-First）」アプローチは、フロントエンド・バックエンド間の整合性バグの最大の温床です。実装前にAPIスペック（契約）を先に定義する「設計先行（Design-First）」を義務化します。
*   **REST API 向け義務の流れ**:
    1.  **Spec-First**: OpenAPI 3.1 スペック（`openapi.yaml`）を先に定義し、PRレビューで承認されてから実装を開始する。
    2.  **Contract-from-Spec**: `openapi-typescript` / `orval` 等のコード生成ツールで、スペックから型定義を自動生成し、手書き型を禁止する。
    3.  **Spec-Sync Gate**: CIに実装とスペックの一致検証を追加し、ドリフトを物理的にブロックする（`redocly lint` / `spectral` 等）。
    ```yaml
    # OpenAPI 3.1 スペック先行定義例
    openapi: '3.1.0'
    info:
      title: User API
      version: '1.0.0'
    paths:
      /users/{id}:
        get:
          operationId: getUserById
          summary: ユーザー取得
          parameters:
            - name: id
              in: path
              required: true
              schema: { type: string, format: uuid }
          responses:
            '200':
              content:
                application/json:
                  schema: { $ref: '#/components/schemas/UserPublicDTO' }
    ```
*   **AsyncAPI（非同期イベント、EDA）**:
    *   イベント駆動アーキテクチャ（§14.4）を採用する場合、AsyncAPI 3.0 スペックでイベントスキーマとチャネルを先行定義してください。
    *   イベントスキーマの変更はSchema Registryで管理し、バージョン互換性を自動検証する。
*   **API Versioning戦略**:
    | バージョニング戦略 | 利用場面 | 例 |
    |:------------|:---------|:---|
    | URL Path | 小規模API・スタートアップ | `/api/v1/users` |
    | Header | 大規模・複数クライアント | `Accept: application/vnd.api.v2+json` |
    | GraphQL メジャーバージョン | 全テナント（非推奨ディレクティブ使用） | `@deprecated(reason: "v2を使用してください")` |
    *   **廃止通知ルール**: APIは一度公開したら少なくとも1年間は旧バージョンを維持すること。Deprecationはヘッダー（`Deprecation`, `Sunset`）で事前通知する。

### 19.2. Data Quality Engineering Protocol（データ品質エンジニアリング）
*   **Context**: AI/LLMの推論精度を決めるのは「モデルの能力」ではなく「データの品質」です。"Garbage in, Garbage out" の原則は2026年においても不変です。データパイプラインの品質基準をエンジニアリング層で定義します。
*   **Data Qualityの5次元**:
    | 次元 | 定義 | 計測例 |
    |:-----|:-----|:--------|
    | **Completeness（完全性）** | 必須フィールドのnull率 | `null_rate < 1%` |
    | **Accuracy（正確性）** | 期待な値範囲内か | `price BETWEEN 0 AND 1000000` |
    | **Consistency（一貫性）** | ユニーク制約違反など | 重複メールアドレス ≤ 0 |
    | **Timeliness（適時性）** | データの遅延 | 最終更新 ≤ 24h前 |
    | **Validity（妥当性）** | 形式規則違反 | `email LIKE '%@%.%'` |
*   **実装義務**:
    *   **dbt Test**: データ変換パイプラインに dbt（data build tool）を導入している場合、`not_null`, `unique`, `accepted_values`, `relationships` の4大dbtテストを全モデルに適用することを義務化します。
    *   **Great Expectations / Soda Core**: dbt以外のパイプラインでは、Great ExpectationsまたはSoda Coreの「データ品質スイート」をCIに組み込み、品質ゲートを構築してください。
    *   **アラート基準**: データ品質違反時は必ずアラートを発報し、データエンジニアリングチームに連絡してください。品質チェックなしに下流サービスへデータが流れることを禁止します。
    ```yaml
    # dbt schema.yml テスト定義例
    models:
      - name: users
        columns:
          - name: id
            tests: [not_null, unique]
          - name: email
            tests: [not_null, unique]
          - name: created_at
            tests: [not_null]
    ```

### 19.3. FinOps ユニットエコノミクスプロトコル
*   **Context**: クラウドコストの単なる削減以上に、「コスト当たりのビジネス価値」を最大化するFinOps Unit Economicsを実践します。
*   **ユニットコスト計測の義務化**:
    *   **定義**: ユニットコスト（Unit Cost）= 特定のビジネスイベント当たりのインフラコスト（例: ユーザー1人当たりコスト、AI推論リクエスト当たりコスト）。
    *   **KPI例**:
        | KPI | 計算式 | 目標値 |
        |:----|:-------|:-------|
        | Cost per Active User (CPAU) | 月次インフラコスト ÷ MAU | 週次で前週比を監視 |
        | Cost per API Call | APIコスト層 ÷ 発行API数 | < $0.001 |
        | AI Cost per Inference | LLMトークンコスト ÷ 推論履行数 | 定期レビュー |
*   **Cost Attribution（コスト配賦）**:
    *   明示なタグ付け義務: 全クラウドリソースに `team`, `service`, `environment`, `cost-center` タグを必ず付けコスト配賦を可能にしてください（§14.2参照）。
    *   **Showback vs Chargeback**: 初期は各チームにコストレポートを共有する「Showback」から始め、成熟したら実際に請求する「Chargeback」へ移行してください。
    *   **FinOpsライフサイクル**: Inform（展望）→ Optimize（最適化）→ Operate（運用）の3フェーズサイクルを四半期ごとに実施してください。
*   **アンチパターン禁止**:
    *   コスト総量のみを見て、ユニットコストを無視すること。
    *   オーバープロビジョニング（§6.3）と同様にユニットコスト悪化もFinOpsの摘患です。

### 19.4. Blameless文化とポストインシデントレビュープロトコル
*   **Context**: 障害発生時に「犯人探し」を行う組織は、再発防止よりも隠蔽を優先し、「見えない障害」を点在化させます。Blameless文化はGoogle SREの核心「安全性」であり、心理的安全性がイノベーションの前提条件です。
*   **Post-Incident Review（PIR）義務**:
    *   全てのSeverity 1・2の障害は、復旧から **72時間以内** にPIRドキュメントを作成してください。
    *   **PIR必須情報**:
        | セクション | 内容 |
        |:----------|:----|
        | **障害概要** | 発生時刻・復旧時刻・Severity・MTTR |
        | **クロノロジー** | 第一発見から復旧までのタイムライン |
        | **根本原因分析** | 5WhysまたはFishbone図による根本原因特定 |
        | **Action Items** | 再発防止策・担当者・期限を明記 |
        | **What Went Well** | 正常に機能したプロセス・検出機構の記録 |
*   **Blamelessの定義**:
    *   実行者を非難するのではなく、**障害を引き起こしたシステム・プロセスの設計上の脆弱性を特定・修正** することに焦点を当ててください。
    *   「気をつければ防げた」形式のトライアルは禁止。「同じ状況で誰でも同じミスを犯せるようなEnvironmentは何が問題か」の視点に切り替えてください。
*   **アクションアイテム追跡義務**: PIRのアクションアイテムは必ずイシュートラッカー（GitHub Issues / Jira）で管理し、次回スプリントに組み込み、実行状況を確実にフォローしてください。放置されたアクションアイテムは「解決されないリスク」です。

### 19.5. Secrets Governance & CVE SLA Protocol（シークレットガバナンス）
*   **Context**: シークレットのリポジトリコミットは後辺性に再現するため「削除しただけで安全」は絶対的に誤りです。シークレット検出の自動化とCVE対応のSLA化は現代のセキュリティレイヤーの必須要件です。
*   **Secrets Detection CI義務化**:
    *   **リアルタイム検出**: `pre-commit` フックに `gitleaks` または `trufflehog` を組み込み、コミット前にシークレットを検出してください。
    *   **CIスキャン**: 全PRでリポジトリ履歴全体（git log）をスキャンするCIジョブを必須としてください。
    *   **SAST Integration**: GitHub Advanced Security・GitGuardian等でリポジトリ歴史の定期スキャンを実施してください。
    ```bash
    # gitleaks pre-commitフック設定例
    # .pre-commit-config.yaml
    repos:
      - repo: https://github.com/gitleaks/gitleaks
        rev: v8.18.0
        hooks:
          - id: gitleaks
    ```
*   **CVE SLA（脆弱性対応期限）**:
    | スコア | 対応期限 | 対応下限 |
    |:-------|:---------|:-------|
    | **Critical（9.0+）** | **発見後24時間以内** | パッチ不能な場合は影響機能を無効化 |
    | **High（7.0–8.9）** | **発見後72時間以内** | 回避策の実施必須 |
    | **Medium（4.0–6.9）** | **次回スプリント内** | バックログに登録 |
    | **Low（0.1–3.9）** | **四半期内** | テックレーダーレビュー時 |
*   **自動スキャン**:
    *   `npm audit --audit-level=high` を CI で必須実行（§4.1参照）。
    *   GitHub Dependabot / Renovate Bot で脆弱性の自動プルリクエストを有効化し、レビュー前置設定を該当スロットに自動化する。
    *   Container Image の脆弱性スキャン: `trivy` / `grype` をCIに組み込み、ビルド毎回でベースイメージの脆弱性を検出してください。
*   **VEX（Vulnerability Exploitability eXchange）プロトコル**:
    *   **背景**: SBOMに記録された脆弱性の多くは「コードパスが実行されない」「当該機能を使っていない」等の理由で実際には **Exploitable でない**ケースがあります。VEX は「この脆弱性は我々の製品に対して悪用不可能である」という根拠をSBOMに添付する標準仕様（CISA / CycloneDX VEX）です。
    *   **実装義務**: CIパイプラインで `trivy sbom --format cyclonedx` により SBOM を生成し、`vex.json`（免除根拠ドキュメント）と組み合わせて CI の脆弱性ゲートを精度向上させてください。
    *   **VEX Statement の必須フィールド**: `vulnerability_id`（CVE ID）, `status`（NOT_AFFECTED / FIXED / UNDER_INVESTIGATION）, `justification`（COMPONENT_NOT_PRESENT等）, `impact_statement`（影響範囲の説明）
*   **CSPM（Cloud Security Posture Management）義務**:
    *   **Law**: クラウドインフラの設定ミス（公開S3バケット・過剰なIAMポリシー・暗号化なしEBSボリューム等）は、侵害の最大要因です。IaCの設定値を静的解析でスキャンすることを義務化します。
    *   **必須スキャナー比較**:
        | ツール | 対象クラウド | 特徴 |
        |:------|:-----------|:-----|
        | **Checkov** | AWS/GCP/Azure/K8s | Terraform/CDK対応のOSS静的解析 |
        | **tfsec** | AWS/GCP/Azure | Terraform特化・高速・CI向き |
        | **KICS** (Checkmarx) | マルチクラウド | IaC全種対応（Terraform/CloudFormation/ARM） |
        | **AWS Security Hub** | AWS | ランタイム設定の継続的検査 |
    *   **CI統合**: PRごとに `checkov -d ./infra --framework terraform --output sarif` を実行し、High以上の設定ミスはCIをブロックしてください。
        ```bash
        # GitHub Actions CSPM統合例
        - name: Run Checkov IaC Scan
          uses: bridgecrewio/checkov-action@master
          with:
            directory: infra/
            framework: terraform
            soft_fail: false   # Highは必ずブロック
            output_format: sarif
        ```

### 19.6. Automated Release Protocol（自動リリースプロトコル）
*   **Context**: リリースノートの手動作成、バージョンバンプの漏れ、CHANGELOGドリフトはいずれも「注意力の浪費」です。Conventional Commits（§12.7）と結合し、リリースプロセスそのものを自動化します。
*   **semantic-release導入義務**:
    *   **自動処理内容**: コミットメッセージの解析 → semverバージョン決定 → CHANGELOG追記 → Git Tag発行 → npm/GitHub Packagesパブリッシュ。
    *   **Commit型とバージョンプロトコル**:
        | Commit Type | semver影響 | 例 |
        |:-----------|:---------|:---|
        | `fix:` | **PATCH** (0.0.x) | `fix: ログイン時のクラッシュ修正` |
        | `feat:` | **MINOR** (0.x.0) | `feat: ストア機能追加` |
        | `feat!:` / `BREAKING CHANGE:` | **MAJOR** (x.0.0) | `feat!: APIレスポンス形式変更` |
    ```json
    // package.json: semantic-release 設定例
    {
      "release": {
        "branches": ["main"],
        "plugins": [
          "@semantic-release/commit-analyzer",
          "@semantic-release/release-notes-generator",
          "@semantic-release/changelog",
          "@semantic-release/github"
        ]
      }
    }
    ```
*   **自動リリースの避けるべきアンチパターン**:
    *   **手動バンプ禁止**: `package.json` の `version` を手動更新することは禁止（自動化と矛盾する）。
    *   **コミットメッセージバイパス禁止**: `chore: bump version` 等の手動バージョン担当コミットは禁止。
    *   **リリースブランチの直接Push禁止**: `main`への直接コミットはHusky Guard（§12.10）で物理的にブロック。

---

## Part XX: AIエージェント・オーケストレーション安全基準 (AI Agent & Orchestration Safety)

> [!CAUTION]
> このパートは2026/2027年において最もリスクの高い新興ドメインです。AIエージェントは「自律的にコードを書き・ツールを実行し・外部APIを呼ぶ」ため、既存のセキュリティモデルでは対処不能な新たな攻撃面を生み出します。**エージェントを導入するすべてのシステムでこのパートの遵守を必須とします。**

### 20.1. AIエージェント・セキュリティモデル (Agent Security Model)
*   **Law**: AIエージェント（LangGraph / AutoGen / CrewAI / OpenAI Agents SDK等）を本番環境に導入する場合、以下の「エージェントセキュリティ4公理」を全て実装しなければなりません。
*   **エージェントセキュリティ4公理（必須）**:
    1.  **Sandboxed Execution（サンドボックス実行）**: エージェントが実行するコード・シェルコマンドは、**インターネットアクセスなし・ファイルシステム制限あり**のサンドボックス（Docker gVisor / Firecracker MicroVM / E2B等）内でのみ実行してください。ホスト環境への直接実行は**絶対禁止**です。
    2.  **Human-in-the-Loop Gate（人間承認ゲート）**: エージェントが「破壊的操作（DELETE/WRITE/PUSH）」を実行しようとする場合、必ず人間の承認を待つ「確認ステップ」を挟んでください。このゲートをプログラムで迂回することは禁止です（§3.8参照）。
    3.  **Blast Radius Minimization（影響範囲最小化）**: エージェントに付与するツール権限は「このタスクに必要な最小スコープ」のみに限定してください。全エンドポイントへのアクセス・全テーブルへの書き込み権限を与えることは「権限爆発」であり禁止します。
    4.  **Audit Trail Obligation（エージェント監査ログ義務）**: エージェントが実行した全ての「ツール呼び出し・判断・出力」を構造化ログとして記録し、最低90日間保持してください。「なぜその判断をしたか」を後から追跡できない設計は禁止です。
```typescript
// エージェント実行ログの最低構造
type AgentAuditLog = {
  session_id: string;           // エージェントセッション識別子
  agent_id: string;             // エージェント種別
  step_index: number;           // 何番目のステップか
  action_type: 'tool_call' | 'llm_inference' | 'human_approval_request';
  tool_name?: string;           // 実行ツール名
  tool_input?: Record<string, unknown>;  // ツール入力（PII除去後）
  tool_output?: unknown;        // ツール出力（サイズ制限付き）
  approved_by?: string;         // 人間承認者ID（Human-in-the-Loop時）
  timestamp: string;            // ISO8601形式
  latency_ms: number;
};
```

### 20.2. MCP（Model Context Protocol）セキュリティ基準
*   **Context**: MCP（Anthropic提唱）はAIエージェントとツール・データソース間の標準プロトコルとして2025-2026年に急速に普及しました。MCPサーバーは「AIに対してツールを公開するAPIサーバー」であり、**適切な認証なしでは本番システムへのバックドアになります**。
*   **MCPサーバー設計義務**:
    *   **認証必須**: MCPサーバーへのアクセスはOAuth 2.0 / API Key認証を必須とし、匿名アクセスを**禁止**します。
    *   **ツール権限スコープ**: MCPが公開するツールはホワイトリスト制とし、**公開スコープを `capabilities` に明示的に宣言**してください。宣言外の操作はサーバー側で拒否してください。
    *   **Input Validation**: MCPを経由して渡されるパラメータは、**サーバーサイドで必ず型バリデーション（Zodスキーマ等）を実施**してください。エージェントからの入力はユーザー入力と同等の信頼レベルで扱ってください。
    *   **Rate Limit**: MCPサーバーにはエージェントセッション単位のRate Limitを設置し、暴走エージェントによるリソース枯渇（コスト爆発）を防いでください。
    ```json
    // MCP Server Capabilities 宣言例
    {
      "protocol": "mcp",
      "capabilities": {
        "tools": [
          { "name": "read_file",  "description": "Read file contents", "scope": "read" },
          { "name": "write_file", "description": "Write file contents", "scope": "write",
            "requires_approval": true }
        ],
        "excluded": ["delete_file", "execute_shell"]  // 明示的除外
      }
    }
    ```

### 20.3. マルチエージェント認可モデル (Multi-Agent Authorization)
*   **Context**: 複数のAIエージェントが連携する「マルチエージェントシステム」では、エージェント間の信頼関係・権限委譲が新たな攻撃面になります。「エージェントAがエージェントBに指示し、Bが本番DBを書き換える」という連鎖を制御する認可モデルが不可欠です。
*   **エージェント間信頼モデル**:
    | 信頼レベル | 定義 | 権限範囲 |
    |:---------|:-----|:--------|
    | **Orchestrator** | ユーザーから直接指示を受けるルートエージェント | タスク分解・Sub-Agentへの指示（ツール実行は不可） |
    | **Sub-Agent** | Orchestratorから委託されたエージェント | 指定されたスコープ内のツール実行のみ |
    | **Tool Server** | エージェントが呼ぶAPIサーバー | ホワイトリスト内のオペレーションのみ |
*   **実装義務**:
    *   **権限継承の禁止**: Sub-AgentはOrchestratorより**大きな権限を持てません**。委託によって権限が拡大することを物理的に防いでください（権限昇格攻撃の防止）。
    *   **エージェントIDの伝播**: エージェント間のすべての呼び出しにおいて、`X-Agent-Session-Id` と `X-Agent-Caller-Id` ヘッダーを伝播させ、監査ログで呼び出し元を追跡可能にしてください。
    *   **Confused Deputy Attack 対策**: Sub-AgentはOrchestratorからの指示を「信頼する」が、Orchestrator自身がInjectionされている可能性を考慮してください。Sub-Agent側でもInput Validation（非許可操作の拒否）を必ず実施してください。

### 20.4. エージェント・ハルシネーション・リスク管理 (Agent Hallucination Risk Management)
*   **Context**: 自律的に行動するAIエージェントが「存在しないAPIを呼び出す」「誤ったパス名を参照する」「不正確な計算に基づいて判断する」等のハルシネーションは、**本番システムへの副作用**（誤ったデータ書き込み・意図しない課金等）を引き起こします。
*   **必須対策**:
    1.  **Structured Output Enforcement（構造化出力強制）**: エージェントのツール選択や判断はFree-Textではなく、JSONスキーマ制約付きのStructured Output（OpenAI Structured Outputs / Anthropic Tool Use）を使用してください。スキーマ外の出力はサーバー側で拒否してください。
    2.  **Verification Step（検証ステップ）**: 重要な判断（「このレコードを削除する」等）の前に、エージェント自身に「本当にこの操作を行ってよいか？根拠は何か？」を再問するReflectionステップを必ず挟んでください。
    3.  **Tool Call Dry Run**: Writeを伴うツール呼び出しは、本番実行前に「Dry Run モード」で影響範囲をシミュレーションし、ログに出力してからHuman Approvalを経て実行してください。
    4.  **Confidence Threshold**: エージェントの判断信頼度スコアが閾値（例: `confidence < 0.8`）を下回る場合は自律実行を中止し、ユーザーにエスカレーションしてください。低信頼での自動実行は禁止です。
    ```typescript
    // 検証ステップ付きエージェント実行パターン
    async function safeAgentAction(action: AgentAction): Promise<void> {
      const verification = await agent.reflect(`
        次のアクションを実行しようとしています:
        Action: ${action.type} on ${action.target}
        根拠: ${action.rationale}
        これは正しいですか？予期せぬ副作用はありますか？
      `);
      if (verification.confidence < 0.8 || verification.hasRisk) {
        await requestHumanApproval(action, verification.concerns);
        return;
      }
      await executeWithAuditLog(action);
    }
    ```

### 20.5. AIエージェント コスト爆発防止プロトコル (Agent Cost Guard)
*   **Context**: 自律エージェントの「無限ループ・再帰的自己呼び出し・不必要な長大コンテキスト」はLLMトークンコストを指数関数的に増大させ、月次コストを数日で超過させる「コスト爆発（Cost Explosion）」を引き起こします。FinOps（§19.3）の観点からも、エージェント実行のコスト制御は義務です。
*   **コスト爆発防止の4ガードレール**:
    1.  **Max Steps Limit（最大ステップ制限）**: エージェントのリエントラントループには必ず `max_iterations` を設定してください。デフォルト上限: **50ステップ**。超過した場合はエラーを返し、人間にエスカレーションしてください。
    2.  **Token Budget Ceiling（トークン予算上限）**: 1エージェントセッションでの累計入力+出力トークン数に上限を設けてください（例: **200,000トークン/セッション**）。超過したセッションは自動中断してください。
    3.  **Cost-per-Session Alert（セッション単価アラート）**: 1エージェントセッションのコスト推定値が閾値（例: **$1.00/セッション**）を超えた時点でリアルタイムアラートを発報してください。
    4.  **Orphan Agent Cleanup（孤立エージェント回収）**: タイムアウトしたエージェントセッション（デフォルト: **10分間**アクティビティなし）は自動的に終了させてください。孤立したエージェントはコストと整合性リスクの両方を生み出します。
    ```typescript
    // エージェントコスト制御の実装例
    const agentRunner = new AgentRunner({
      maxIterations: 50,           // 最大ステップ数
      maxTokens: 200_000,          // セッション内トークン予算
      timeoutMs: 10 * 60 * 1000,  // 10分でタイムアウト
      onCostAlert: async (estimatedCost) => {
        if (estimatedCost > 1.0) {
          await notifySlack(`⚠️ Agent cost alert: $${estimatedCost.toFixed(2)}`);
          throw new AgentCostExceedError(estimatedCost);
        }
      },
    });
    ```
*   **エージェントコスト計測義務**: 全エージェント実行において `input_tokens`, `output_tokens`, `tool_calls_count`, `estimated_cost_usd` を監査ログに記録し、FinOpsダッシュボード（§19.3）に集計してください。

---

## Part XXI: プライバシー・エンジニアリング (Privacy Engineering)

> [!CAUTION]
> プライバシーは「コンプライアンス部門の問題」ではなく「エンジニアリングの設計責任」です。GDPR・EU AI Act・CCPA・個人情報保護法（改正2022年）の同時適用時代において、プライバシー違反はシステムの即時停止命令と数十億円規模の制裁金リスクを内包します。**設計フェーズから組み込むこと（Privacy by Design）が唯一の正解です。**

### 21.1. Privacy by Design（プライバシー設計原則）

> [!IMPORTANT]
> Ann Cavoukian博士の「Privacy by Design 7原則」を全システム設計のチェックリストとして義務付けます。プライバシーへの配慮は事後的な対策ではなく、アーキテクチャ上の基本設計要件です。

*   **PbD 7原則（全項目を設計フェーズで確認すること）**:
    | 原則 | 設計チェック |
    |:----|:-----------|
    | **1. Proactive, not Reactive** | プライバシーリスクを事前に特定し、発生を防止する |
    | **2. Privacy as the Default** | 何も設定しなくても最も安全なデフォルト（最小収集）になっているか |
    | **3. Privacy Embedded in Design** | プライバシー保護がアーキテクチャの一部（後付け機能ではない）か |
    | **4. Full Functionality (Positive-Sum)** | セキュリティとプライバシーはトレードオフではなく両立させる |
    | **5. End-to-End Security** | データの収集から削除まで全ライフサイクルで保護されているか |
    | **6. Visibility & Transparency** | ユーザーが自分のデータを確認・修正・削除できるか |
    | **7. Respect for User Privacy** | ユーザーを中心に設計し、データ主権を持てるか |
*   **DPIA（データ保護影響評価）義務化**:
    *   **対象**: 高リスク処理（大規模個人データ処理・生体情報・位置情報・子供向けサービス・プロファイリング）を含む機能追加時は、必ず **DPIA（Data Protection Impact Assessment）** を実施してください。
    *   **実施タイミング**: 実装着手前（Blueprint作成フェーズ）。後付けDPIAは意味を持ちません。
    *   **必須記載項目**: データフロー図・リスク特定・軽減策・残留リスク評価・DPO（データ保護責任者）承認。

### 21.2. データ最小化プロトコル（Data Minimization Protocol）

*   **Law**: 収集するデータは「今このサービスに絶対必要なデータのみ」に限定します。「将来使うかもしれないから」での収集は個人情報保護法違反のリスクがあります。
*   **実装チェックリスト**:
    1.  **Purpose Limitation**: 収集目的を明示し、目的外利用を禁止してください。テーブル定義のコメントに収集目的を必ず明記してください。
    2.  **Storage Limitation**: データの保管期限を全てのPIIデータに設定してください。期限超過データは自動的に匿名化または削除してください。
    3.  **Field-Level Sensitivity Classification**: 全テーブルの全カラムに感度レベル（`PUBLIC` / `INTERNAL` / `CONFIDENTIAL` / `RESTRICTED`）を付与してください。
        ```sql
        -- カラムコメントに感度レベルを明記する義務（PostgreSQL）
        COMMENT ON COLUMN users.email IS 'CONFIDENTIAL: 本人識別情報。GDPRデータ主体の権利対象。保管期限: アカウント閉鎖後3年';
        COMMENT ON COLUMN users.username IS 'INTERNAL: 表示名。公開設定によりPUBLICになりうる';
        ```
    4.  **PII Catalog Obligation**: 全PIIフィールドの場所・種別・保管期限・暗号化状態を記録した「PIIカタログ」を `docs/pii-catalog.md` に維持してください。

### 21.3. Consent Management Protocol（同意管理プロトコル）

*   **Context**: 2026年以降、「暗黙の同意」「事前チェック済みのオプトイン」「撤回困難な拒否フロー」はGDPR・CCPAにより違反とみなされます。
*   **同意取得の4要件**:
    1.  **Freely Given（自由な選択）**: サービス利用条件と同意をバンドルしてはなりません。必須機能と分析収集の同意は分離してください。
    2.  **Specific（特定性）**: 「全てに同意する」のような包括的な同意は無効です。目的別に個別の同意を取得してください。
    3.  **Informed（十分な情報）**: 何のために収集するか・誰に共有するかを平易な言語で説明してください（法律用語禁止）。
    4.  **Unambiguous（明確な行動）**: チェックボックスは「未チェック」がデフォルトであること。スクロールまたはページ訪問を「同意」とみなすことは禁止。
*   **同意の撤回義務**:
    *   同意の撤回は、取得と同等の容易さで行えなければなりません（GDPR Article 7(3)）。
    *   撤回後、30日以内に関連データを削除またはオプトアウト処理してください。
*   **Consent Management Platform (CMP) 統合**:
    *   Cookie同意には、IAB TCF 2.2準拠のCMP（OneTrust / Cookiebot / Usercentrics等）を使用してください。
    *   CMPのバナーが表示されるまでGoogle Analytics・Meta Pixel等のサードパーティスクリプトが実行されないよう、スクリプトのロードをブロックしてください。

### 21.4. Right to be Forgotten Implementation（忘れられる権利の実装）

*   **Law**: GDPR Article 17（消去権）および個人情報保護法第35条（利用停止・消去）に基づき、ユーザーのデータ削除要求に対応できる仕組みを実装してください。「技術的な理由で削除できません」は法的に通用しません。
*   **実装義務**:
    1.  **Hard Delete vs Soft Delete**: PIIを含むレコードの「Soft Delete（論理削除）」は、物理データが残存するため削除権の行使として不完全です。**Anonymization（匿名化）** または **Physical Deletion（物理削除）** を実装してください。
    2.  **Cascading Deletion Protocol**: 親レコード削除時に関連する全子レコードのPIIを連鎖削除する処理を自動化してください（`ON DELETE CASCADE` または Application-side Cascade）。
    3.  **Deletion Audit Trail**: 「誰が・いつ・なぜ削除要求を出し・どのデータを削除したか」の監査ログを保持してください（削除の証明のために削除ログは必要です）。
    4.  **72-Hour SLA**: 削除要求を受け取ってから主要システムからの削除完了まで最大 **72時間** を目標とし、サードパーティへの削除通知は30日以内に完了してください。
    ```typescript
    // 匿名化パターン（物理削除できない場合のフォールバック）
    async function anonymizeUser(userId: string): Promise<void> {
      await db.users.update(userId, {
        email:        `deleted-${userId}@anonymous.invalid`,
        display_name: `削除済みユーザー`,
        phone:        null,
        avatar_url:   null,
        deleted_at:   new Date().toISOString(),
      });
      await anonymizeCascade(userId);
    }
    ```

### 21.5. データ転送・国際移転プロトコル（Cross-Border Data Transfer Protocol）

*   **Law**: EUの個人データを欧州経済領域（EEA）外に転送する場合、適切な保護措置（Standard Contractual Clauses / Binding Corporate Rules / Adequacy Decision）なしの転送は禁止です。
*   **実装義務**:
    *   **データレジデンシーの記録**: データが実際に保管・処理されるリージョンを全PIIデータに対してPIIカタログ（§21.2）に記録してください。
    *   **Adequacy Country List**: EUが適切性認定した国（日本・英国・スイス等）以外へのEU PIIの転送は、SCCなしには禁止です。
    *   **SCC Automation**: SCCを利用している場合、ベンダー契約更新時に自動的にSCCの最新版（2021年版）への更新確認を行ってください。
    *   **Transfer Impact Assessment (TIA)**: 第三国への転送において、現地の法律がEUの保護水準を下回る場合（例: 米国のFISA 702）は、TIAを実施し補完的対策を実装してください。

### 21.6. WebAuthn / Passkey Engineering Standard（パスキー実装標準）

*   **Context**: 2026年においてパスワードは「時代遅れのセキュリティ手段」です。フィッシング耐性のある認証として、FIDO2/WebAuthnベースのPasskeyは、Apple・Google・Microsoftの全プラットフォームサポートが完成し、実用的な標準となりました。
*   **Passkey採用義務**:
    *   **新規システム**: 新規認証システムはPasskeyをプライマリ認証として設計してください。パスワード認証はレガシーフォールバックとして`/settings/security`からのみ有効化可能にしてください。
    *   **既存システム**: 既存のパスワード認証システムには、Passkey登録オプションを追加し、移行を促進してください。
*   **実装基準**:
    ```typescript
    // WebAuthn Registration（登録）フロー
    import { generateRegistrationOptions } from '@simplewebauthn/server';
    
    const options = await generateRegistrationOptions({
      rpName: 'Your App Name',
      rpID: process.env.WEBAUTHN_RP_ID!,
      userID: userId,
      userName: userEmail,
      attestationType: 'none',                // プライバシー保護: 機器情報を送信しない
      authenticatorSelection: {
        residentKey: 'required',              // Discoverable Credential必須
        userVerification: 'required',         // 生体認証/PINを必須
      },
    });
    ```
    *   **Roaming vs Platform Authenticator**: UIで「セキュリティキー（Roaming: YubiKey等）」と「このデバイス（Platform: Face ID/Windows Hello等）」を区別し、ユーザーが複数のAuthenticatorを登録できる設計にしてください。
    *   **Recovery Path Mandatory**: Passkey紛失時のアカウント回復フロー（メール認証 + OTP等）を必ず実装してください。「Passskeyがないとログインできない」は受容不能な設計です。
    *   **Conditional UI**: ログインフォームでは `autocomplete="username webauthn"` を設定し、ブラウザのPasskey自動提案UIを有効化してください。

### 21.7. EU AI Act コンプライアンス・プロトコル（EU AI Act Compliance）

*   **Context**: EU AI Act（2024年8月施行・段階的適用開始）は、AIシステムをリスクレベルに応じて分類し、高リスクAIには厳格な要件を課します。2026年以降、EU市場向けAIシステムはこの規制への対応が必須です。
*   **リスク分類（AIシステムを必ず分類すること）**:
    | リスクレベル | 定義 | 規制要件 |
    |:-----------|:----|:--------|
    | **禁止（Unacceptable）** | サブリミナル操作・社会スコアリング・リアルタイム生体認証（公共空間）等 | **使用禁止** |
    | **高リスク（High-Risk）** | 採用・信用評価・医療診断・重要インフラ管理等 | 厳格な透明性・人間監視・登録義務 |
    | **限定リスク（Limited）** | チャットボット・ディープフェイク生成等 | 透明性開示義務（AIであることの告知） |
    | **最小リスク（Minimal）** | スパムフィルター・推薦システム等 | 自主的行動規範のみ |
*   **高リスクAIの必須要件**:
    1.  **Technical Documentation**: AIシステムの設計・訓練データ・テスト結果を文書化し、規制当局に提出可能な状態に維持してください。
    2.  **Human Oversight Mandate**: 高リスクAIの最終決定には必ず人間の承認ステップを挿入してください。フルオートの意思決定は禁止です。
    3.  **Accuracy & Robustness Testing**: 継続的なパフォーマンステストと、社会的弱者グループへのバイアス検証を義務付けます。
    4.  **EU AI Act Registration**: 高リスクAIの提供者はEU AI Act Databaseへの登録（2026年8月以降）が義務です。
*   **限定リスクAIの開示義務**:
    *   チャットボット・音声アシスタント等は、対話の開始時に「AIと話していること」をユーザーに明示してください。
    *   AIが生成したコンテンツ（テキスト・画像・音声）にはメタデータまたはウォーターマークを付与してください（C2PA標準推奨）。

---

## Part XXII: ランタイム・セキュリティ強化 (Advanced Runtime Security Hardening)

> [!CAUTION]
> ビルド時のセキュリティチェックは「スタート地点」に過ぎません。2026年のトップ脅威（ゼロデイ・コンテナエスケープ・サプライチェーン汚染）はランタイムで発生します。本パートは「動いているシステムを守る」ためのランタイム防衛層の構築義務を定めます。

### 22.1. SLSA Level 3+ サプライチェーン強化

*   **Law**: §3.5（ソフトウェアサプライチェーンセキュリティ）のSLSA Level 2要件を拡張し、本番デプロイには **SLSA Level 3** 以上を目標とします。
*   **SLSA Level 3の追加要件**:
    *   **Hardened Build Platform**: ビルドはGitHub Actions / Google Cloud Build等の**信頼されたプラットフォーム**で実行し、カスタムランナーによる汚染を防いでください。
    *   **Non-forgeable Provenance（偽造不可な来歴）**: ビルドの来歴（Provenance）は`sigstore/cosign`で**デジタル署名**し、デプロイ前に署名検証を必須としてください。
    *   **Isolated Build**: ビルドプロセスはネットワーク隔離されたサンドボックスで実行し、ビルド中の外部ネットワークアクセスを遮断してください。
    ```yaml
    # GitHub Actions: Cosign による成果物署名の例
    - name: Sign container image with Cosign
      uses: sigstore/cosign-installer@v3
    - run: |
        cosign sign --yes \
          --key env://COSIGN_PRIVATE_KEY \
          ${{ env.IMAGE_NAME }}@${{ steps.build.outputs.digest }}
      env:
        COSIGN_PRIVATE_KEY: ${{ secrets.COSIGN_PRIVATE_KEY }}
    - name: Verify image signature
      run: |
        cosign verify \
          --key env://COSIGN_PUBLIC_KEY \
          ${{ env.IMAGE_NAME }}
    ```

### 22.2. eBPF-based Runtime Security（ランタイム脅威検知）

*   **Context**: eBPF（extended Berkeley Packet Filter）は、カーネルレベルでシステムコールを監視し、悪意ある挙動をゼロオーバーヘッドで検知できる2026年の標準ランタイムセキュリティ技術です。
*   **推奨ツールスタック**:
    | ツール | 分類 | 主な機能 | 採用基準 |
    |:------|:----|:--------|:--------|
    | **Tetragon** (Cilium) | eBPF Runtime Security | プロセス実行・ネットワーク接続・ファイル操作の監視とポリシー強制 | Kubernetes環境・OSS |
    | **Falco** (CNCF) | Cloud-Native Runtime Security | コンテナ内の疑わしい挙動検知（特権昇格・シェル起動等）| マルチクラウド・広範なルールセット |
    | **Cilium** | eBPF Network Policy | L7可視性・mTLS強制・ネットワークポリシー | サービスメッシュ代替 |
*   **必須監視ルール（Falco）**:
    ```yaml
    - rule: Terminal shell in container
      desc: A shell was spawned inside a container
      condition: >
        spawned_process and container
        and shell_procs
        and not (container.image.repository = "trusted/debug-image")
      output: >
        Shell spawned in container
        (user=%user.name container=%container.name image=%container.image.repository
         cmd=%proc.cmdline)
      priority: WARNING
    ```
*   **アラート連携**: Falco/Tetragonのアラートは**Slack + PagerDuty**に即時転送し、P1インシデントとして扱ってください。

### 22.3. コンテナ・セキュリティ強化プロトコル

*   **Distroless Image Mandate**: 本番コンテナは**Distrolessイメージ**（Google Distroless / Chainguard Images等）を使用してください。シェル・パッケージマネージャー・不要なシステムユーティリティを含む通常のLinuxディストリビューションイメージは、攻撃面を不必要に拡大するため禁止します。
    ```dockerfile
    # マルチステージビルド + Distroless の標準構成
    FROM node:20-slim AS builder
    WORKDIR /app
    COPY package*.json ./
    RUN npm ci --only=production
    COPY . .
    RUN npm run build

    FROM gcr.io/distroless/nodejs20-debian12 AS runtime
    WORKDIR /app
    COPY --from=builder /app/dist ./dist
    COPY --from=builder /app/node_modules ./node_modules
    USER nonroot
    CMD ["dist/index.js"]
    ```
*   **Read-Only Root Filesystem**: Kubernetes PodSpecで `readOnlyRootFilesystem: true` を設定し、コンテナ脱出後のファイルシステム操作を防いでください。writable領域は必要最小限の `emptyDir` または `tmpfs` マウントに限定してください。
*   **Pod Security Standards: Restricted Profile を全本番Podに適用すること**:
    ```yaml
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 65534
        seccompProfile:
          type: RuntimeDefault
        fsGroup: 65534
      containers:
        - securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop: ["ALL"]
    ```

### 22.4. mTLS（相互TLS）とサービスメッシュ義務

*   **Context**: マイクロサービス間通信を平文（HTTP）で行うことは「内部ネットワークを信頼する」というZero Trust違反です。
*   **mTLS義務**:
    *   **サービス間通信**: 全てのマイクロサービス間通信はmTLSで暗号化してください。Istio / Linkerd / Cilium等のサービスメッシュを利用してSidecar/eBPFでmTLSを自動適用することを推奨します。
    *   **証明書管理**: サービス証明書はcert-manager（Kubernetes）で自動発行・自動更新し、手動更新を排除してください。デフォルトの証明書有効期限: **90日**。
    *   **SPIFFE/SPIRE**: 証明書のIDにSPIFFE（Secure Production Identity Framework for Everyone）を採用し、サービスIDをKubernetes Service Accountに紐付けてください。
*   **TLS設定基準**:
    | 設定項目 | 要件 |
    |:-------|:----|
    | TLS Version | TLS 1.3 のみ。TLS 1.2以下は禁止 |
    | Cipher Suites | `TLS_AES_128_GCM_SHA256`, `TLS_AES_256_GCM_SHA384`, `TLS_CHACHA20_POLY1305_SHA256` のみ許可 |
    | Certificate Lifetime | 最大90日（Leaf証明書）|
    | HSTS | `max-age=31536000; includeSubDomains; preload` |
    | HPKP | 非推奨（使用禁止）。CT（Certificate Transparency）ログ監視を使用すること |

### 22.5. Secrets Detection & Rotation Automation（シークレット検知・自動ローテーション）

*   **Law**: §3.6（シークレットローテーション）と §19.5（Secrets Governance）を基盤とし、**ローテーションの完全自動化**を追加義務として課します。「スケジュールを守って手動でローテーション」は人的エラーを内包するため、自動化が唯一の正解です。
*   **自動ローテーション実装（Vault Dynamic Secrets）**:
    ```bash
    # HashiCorp Vault: PostgreSQL動的シークレット（毎回短命の認証情報を自動生成）
    vault write database/roles/api-readonly \
        db_name=production-db \
        creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
        default_ttl="1h" \
        max_ttl="24h"
    ```
*   **GitHub Actions シークレット自動更新パターン**:
    ```yaml
    on:
      schedule:
        - cron: '0 2 * * 0'  # 毎週日曜日 AM2時
    jobs:
      rotate-secrets:
        runs-on: ubuntu-latest
        steps:
          - name: Rotate API Key
            run: |
              NEW_KEY=$(vault read -field=api_key secret/external/service)
              gh secret set EXTERNAL_API_KEY --body "$NEW_KEY"
    ```

### 22.6. Zero-Trust Network Access（ZTNA）実装

*   **Context**: 従来のVPN（境界型セキュリティ）は「社内ネットワーク＝信頼できる」という前提に立っており、Zero Trust原則と根本的に矛盾します。ZTNA（Zero-Trust Network Access）はVPNに代わる2026年のリモートアクセス標準です。
*   **ZTNA実装要件**:
    *   **Device Trust**: アクセスするデバイスの健全性（パッチ適用状態・EDR導入・ディスク暗号化）を検証するデバイス証明書を要求してください。ツール例: Cloudflare Access / Tailscale / BeyondCorp Enterprise。
    *   **Continuous Authorization**: 初回認証後も、セッション継続中にデバイス状態・ユーザー行動を継続評価し、リスクスコアが閾値を超えた場合は再認証を要求してください。
    *   **Micro-Segmentation**: 「本番DB接続が許可されているサービスアカウント」は「他の全サービスには到達できない」よう、ネットワークレベルで分割してください。Kubernetes Network PolicyまたはCiliumでL4/L7レベルのMicro-Segmentationを実装してください。

### 22.7. Memory Safety & Secure Coding Standards（メモリ安全性と安全なコーディング）

*   **Context**: 米国CISA・NSAが2023-2026年に発出した「Memory Safety Roadmap」において、C/C++等のメモリアンセーフ言語によるBufferOverflow・Use-After-Freeはシステムソフトウェアの脆弱性の最大70%を占めると示されています。
*   **言語選定ガイドライン**:
    *   **新規システムコンポーネント（セキュリティクリティカルな部分）**: Rust / Go / Swift / Kotlin等のメモリ安全な言語を優先選定してください。
    *   **WASMモジュール（§13.14参照）**: CPU負荷の高い処理はRustで実装しWASMにコンパイルすることで、JavaScriptとメモリ安全なコードの架け橋を実現してください。
    *   **C/C++の使用が不可避な場合**: Address Sanitizer (ASAN) / Undefined Behavior Sanitizer (UBSan) / Memory Sanitizer (MSan) を全CI実行に必須として組み込んでください。
*   **Node.js / TypeScript 固有の安全コーディング**:
    *   **Prototype Pollution 防止**: `Object.create(null)` または `Object.freeze()` を使用し、プロトタイプ汚染攻撃を防いでください。
    *   **ReDoS（正規表現DoS）防止**: ユーザー入力を含む正規表現は `safe-regex` または `vuln-regex-detector` でCI検証を行ってください。
    *   **Path Traversal 防止**: ユーザー入力を含むファイルパスは必ず `path.resolve()` + ベースディレクトリ検証でサニタイズしてください。
        ```typescript
        // Path Traversal防止パターン
        import path from 'path';
        const BASE_DIR = path.resolve('/app/uploads');
        function safeReadFile(userInput: string): string {
          const resolved = path.resolve(BASE_DIR, userInput);
          if (!resolved.startsWith(BASE_DIR + path.sep)) {
            throw new Error('Path traversal detected');
          }
          return fs.readFileSync(resolved, 'utf-8');
        }
        ```

### 22.8. Security Champions Program（セキュリティ・チャンピオン制度）

*   **Context**: セキュリティはセキュリティチームだけの責任ではありません。各開発チームに「Security Champion」を配置し、セキュリティをエンジニアリングプロセスの日常に組み込む体制が2026年の標準組織モデルです。
*   **Security Champion の責務**:
    | 責務 | 頻度 | 内容 |
    |:----|:----|:----|
    | **脅威モデリング参加** | 新機能ごと | STRIDE/LINDDUN手法でリスクを事前特定 |
    | **セキュリティレビュー** | PR単位 | セキュリティ観点（§12.8）の専門確認 |
    | **脆弱性トリアージ** | 週次 | High/Criticalの優先度判断と対応調整 |
    | **チーム向け啓発** | 月次 | 最新の脅威・ベストプラクティスの共有 |
*   **脅威モデリング義務化（STRIDE）**:
    *   **対象**: 認証・認可・決済・個人データ処理を含む新機能。
    *   **STRIDE分析**:
        | カテゴリ | 脅威の種類 | 確認事項 |
        |:--------|:---------|:--------|
        | **S**poofing | なりすまし | JWTの発行者検証は完全か |
        | **T**ampering | 改ざん | RLSとCSRF対策は完全か |
        | **R**epudiation | 否認 | 監査ログは改ざん不能か |
        | **I**nformation Disclosure | 情報漏洩 | 全APIレスポンスにPIIが混入していないか |
        | **D**enial of Service | サービス妨害 | Rate LimitとCircuit Breakerは機能するか |
        | **E**levation of Privilege | 権限昇格 | RBACのロール定義は最小権限か |
    *   脅威モデリングの結果はADR（§16.3）に記録し、発見されたリスクは全てIssueで追跡してください。

---

