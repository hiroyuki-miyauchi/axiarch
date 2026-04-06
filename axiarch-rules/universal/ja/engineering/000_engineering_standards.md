# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-31

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「コードは資産ではなく負債 — すべての行はその存在意義を証明しなければならない。」
> すべてのエンジニアリング判断はスピードよりも正確性・セキュリティ・保守性を優先しなければならない。
> **セキュリティ > 正確性 > 保守性 > パフォーマンス > 開発速度** の優先順位を厳守せよ。
> この文書はエンジニアリング品質と標準に関するすべての設計判断の最上位基準である。
> **13パート・80セクション構成。**

---

## 目次

| Part | トピック | セクション | セクション数 |
|------|---------|-----------|:--:|
| I | コード品質とクリーンコード | §1.0 – §1.9 | 10 |
| II | インフラとパフォーマンス | §2.0 – §2.5 | 6 |
| III | 設計によるセキュリティ (DevSecOps) | §3.0 – §3.5 | 6 |
| IV | 技術的負債とクリーンアップ | §4.0 – §4.4 | 5 |
| V | AIファースト開発 | §5.0 – §5.4 | 5 |
| VI | グリーンコーディング | §6.0 – §6.2 | 3 |
| VII | ゼロバグ・ポリシー | §7.0 – §7.3 | 4 |
| VIII | 継続的学習と検証 | §8.0 – §8.2 | 3 |
| IX | 互換性とテスト | §9.0 – §9.2 | 3 |
| X | Gitとバージョン管理 | §10.0 – §10.6 | 7 |
| XI | ドキュメント運用 | §11.0 – §11.2 | 3 |
| XII | エンジニアリング品質プロトコル | §12.1 – §12.12 | 12 |
| XIII | 高度アーキテクチャ原則 | §13.1 – §13.13 | 13 |
| | | **合計** | **80** |

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
*   全ての入力（ユーザー入力、APIレスポンス）を疑います。バリデーションはクライアントとサーバーの両方で行います。

### 3.1. 機密情報管理 (Secrets Management)
*   APIキーや秘密鍵はコードにコミットしません。`.env` ファイルとシークレットマネージャーを使用します。
*   **The Single Source of Config**: コードの各所で直接 `process.env.NEXT_PUBLIC_...` を参照することは禁止です。必ず `src/lib/config` で一元管理し、存在チェック（Validation）を行ってください。

### 3.2. 環境変数テンプレート同期 (Environment Template Sync)
*   **Law**: プロジェクトルートに `.env.example` を常設し、必要な全環境変数の**キーのみ**を記録する義務を負います。
*   **Sync Mandate**: 新しい環境変数を追加した場合、**同一PRで** `.env.example` も更新しなければなりません。
*   **Git Safety**: `.env.local` / `.env.production` 等の実値を含むファイルは `.gitignore` に含め、**絶対にコミットしてはなりません**。

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

## Part VI: グリーンコーディング (Green Coding & Sustainability)

### 6.0. エネルギー効率 (Energy Efficiency)
*   **アルゴリズム**: 計算量（O記法）を意識し、無駄なCPUサイクルを消費しないコードを書きます。これはバッテリー寿命と地球環境の両方を守ります。
*   **ダークモード**: 有機EL（OLED）デバイスでの消費電力を抑えるため、真の黒（#000000）を使用したダークモードを推奨します。

### 6.1. データ転送量最適化 (Data Transfer Optimization)
*   **圧縮**: 画像や動画は必ず最適化（AVIF/H.265）し、ネットワーク帯域の浪費を防ぎます。
*   **Cache Maximization**: CDNキャッシュヒット率 **80%以上** を目標とし、静的アセットのオリジン負荷を最小化します。

### 6.2. Centralized Storage Shield（ストレージ集約）
*   画像実体はBaaSストレージ（Origin）に集約し、配信はCDNのOptimization機能を経由させることで、コストとパフォーマンスを両立します。

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

---

## Part X: Gitとバージョン管理 (Git & Version Control)

### 10.0. Trunk Based Development（トランクベース開発）
*   **原則**: 長寿命のブランチは廃止し、短命のブランチから `main` へ頻繁に（毎日）マージします。
*   **Stacked Diffs**: 巨大なPRを避け、依存関係のある小さなPRを積み重ねる手法を推奨します。
*   **Branch Naming Standard**: ブランチ名は `type/summary` 形式で統一します（例: `feat/user-profile`, `fix/login-bug`）。Types: `feat`, `fix`, `refactor`, `chore`。

### 10.1. コミット & PR基準 (Commit & PR Standards)
*   **Conventional Commits**: `type(scope): subject` 形式を厳守します。本文には日本語で詳細を記述します。
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
    *   **Supreme Directive: The AI Git Ban**: AIによるGit操作の絶対禁止については、`000_core_mindset.md` の Rule 8.1 を参照。
    *   **The Automated Deployment Mandate (CD First)**: 本番環境へのデプロイを手動コマンドで行うことは**完全禁止**。CI/CDパイプライン経由のみ。
    *   **The Architectural Preservation Protocol**: プロジェクトの中核機能ファイルには `@preservation_level CRITICAL` ヘッダーを付与し、AIの独断での破壊的変更を防止してください。
*   **セキュリティ**: APIキー等の機密情報は絶対にコミットせず、CIでシークレットスキャン（TruffleHog）を義務付けます。
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
*   **Mermaid.js**: アーキテクチャ図は画像ではなくコード（Mermaid）で管理し、陳腐化を防ぎます。
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
*   **Action**: エラーメッセージやバリデーションメッセージは、全て日本語化してください。

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
    *   **Select Specification Pattern**: `SELECT *` や `.select('*')` を禁止します。必要なカラムのみを明示的に列挙してください。
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

---

## Appendix A: 逆引き索引

| キーワード | セクション | 関連ルール |
|-----------|----------|-----------|
| ネーミング / kebab-case | §1.0 | `340_web_frontend`, `342_mobile_flutter` |
| DTO / 型変換 | §13.1, §13.6 | `340_web_frontend` |
| パフォーマンス / LCP / CWV | §2.2 | `340_web_frontend`, `502_site_reliability` |
| DevSecOps / セキュリティ | §3.0 – §3.5 | `600_security_privacy`, `601_data_governance` |
| サプライチェーンセキュリティ | §3.5 | `600_security_privacy` |
| 技術的負債 | §4.0 – §4.4 | `720_cloud_finops` |
| AIファースト / コードレビュー | §5.0 – §5.4 | `400_ai_engineering` |
| グリーンコーディング | §6.0 – §6.2 | `720_cloud_finops` |
| ゼロバグ・ポリシー | §7.0 – §7.3 | `700_qa_testing`, `503_incident_response` |
| Git / バージョン管理 | §10.0 – §10.6 | `502_site_reliability` |
| ドキュメント運用 | §11.0 – §11.2 | `500_internal_tools` |
| Feature Flags | §13.13 | `502_site_reliability`, `700_qa_testing` |
| ミューテーション整合性 | §13.5 | `340_web_frontend` |
| CQRS / キャッシュ | §13.4 | `502_site_reliability` |
| 認証 / アクセス制御 | §13.10 | `600_security_privacy` |
| マイグレーション安全 | §13.12 | `502_site_reliability` |

