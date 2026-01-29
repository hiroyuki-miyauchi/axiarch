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
