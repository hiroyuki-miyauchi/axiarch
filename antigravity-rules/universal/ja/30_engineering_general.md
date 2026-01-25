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

## 4. 技術的負債とクリーンアップ (Technical Debt & Cleanup)
*   **負債の返済 (Debt Paydown)**:
    *   スプリントの **20%** は技術的負債の返済（リファクタリング、ライブラリ更新）に充てます。
*   **テックレーダー (Tech Radar)**:
    *   **定期更新**: 依存ライブラリは四半期ごとに更新し、常に「安全な最先端（Bleeding Edge）」を維持します。
*   **デジタル5S (Digital 5S)**:
    *   **整理 (Seiri)**: 未使用のコード（Dead Code）、画像、ファイルは即座に削除します。コメントアウトされたコードを残しません。

## 5. AIファースト開発 (AI-First Engineering)
*   **Prompt Driven Development (PDD)**:
    *   **原則**: コードは人間が書くものではなく、AIに書かせるものです。「プロンプト」こそが真のソースコードです。
    *   **AIフレンドリー**: 変数名や関数名は、AIが文脈を理解しやすいように、極めて記述的（Descriptive）にします（例: `x` ではなく `daysSinceLastLogin`）。
*   **RAG最適化 (RAG Optimization)**:
    *   **モジュール化**: ファイルサイズは小さく保ち（Atomic）、AIのコンテキストウィンドウを圧迫しないようにします。
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
*   **デプロイメント安全プロトコル (Deployment Safety Protocol)**:
    *   **No Unauthorized Push**: AIエージェントは、ユーザーの明示的な許可なしに `git push` を実行してはなりません。
    *   **Pre-Check**: Push前には必ず `tsc --noEmit` (Type Check) と `npm run build` (Build Check) をローカルで通過させます。
*   **セキュリティ**:
    *   APIキー等の機密情報は絶対にコミットせず、`.env` を使用します。CIでシークレットスキャン（TruffleHog）を義務付けます。

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
*   **Law**: 英語のエラーメッセージはユーザーの離脱を招きます。
*   **Action**: エラーメッセージやバリデーションメッセージは、全て（Zodカスタムエラー等も含め）日本語化してください。
