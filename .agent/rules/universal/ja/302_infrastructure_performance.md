# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

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
        *   **The License Quarantine (AGPL Block)**: ライセンスガバナンスの詳細については、600番台（Security & Privacy） の Rule 5 を参照し、**AGPL (Affero GPL)** の使用防止を徹底してください。
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
*   **Schema Trust Protocol (No Ghost Columns)**:
    *   **Law**: 設計書（Blueprint）に予定されているが、DBマイグレーションがまだ適用されていないカラム名をクエリ（SELECT/INSERT/UPDATE）で使用することを禁止します。存在しない列へのアクセスはページ全体をクラッシュさせます。
    *   **Action**: クエリで使用するカラムは「現在、確実に存在する」ものに限定し、未実装機能のデータはアプリケーション層の定数（Default Config）で補完してください。
