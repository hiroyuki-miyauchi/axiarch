# 70. QAとテスト戦略 (QA & Testing Strategy)

## 1. シフトレフト・テスティング (Shift Left Testing)
*   **早期発見 (Early Detection)**:
    *   QAプロセスを開発の最終工程ではなく、要件定義や設計段階から開始します。
    *   **静的解析**: ESLint, SwiftLint, Detektなどの静的解析ツールをCIに組み込み、コードレビュー前に自動的に問題を検出します。
*   **テストピラミッド (Testing Pyramid)**:
    *   **Unit Tests (70%)**: 実行速度が速く、安定しているユニットテストを基盤とします。カバレッジ目標は80%以上としますが、数値よりも「重要なロジックの網羅」を重視します。UIコンポーネントの単体テストはコスト対効果が低いため推奨しません。
    *   **Integration Tests (20%)**: APIとDB、コンポーネント間の連携を確認します。
    *   **E2E Tests (10%)**: ユーザーのクリティカルパス（登録、決済、主要機能）のみを対象とし、メンテナンスコストを抑えます。決済・ログイン等の重要フローのみ自動化します。
    *   **Priority**: 1. Type Check(tsc) > 2. Lint > 3. Manual > 4. E2E > 5. Unit. 静的解析（tsc）こそが最強のテストです。
*   **モック戦略 (Mock First Strategy)**:
    *   **Offline Dev**: 外部API（Stripe, SendGrid）がない状態でも開発できるよう、`MOCK_MODE` を実装します。APIキーがない場合は自動的にモックが応答し、開発を止めません。

## 2. 不安定なテストの排除 (Flaky Test Management)
*   **即時対応 (Immediate Action)**:
    *   結果が不安定なテスト（Flaky Test）は、開発者の信頼を損なう最大の敵です。発見次第、即座に修正するか、修正されるまで無効化（Skip）します。
    *   **リトライ禁止**: テストの失敗を隠蔽する「自動リトライ」は原則禁止し、根本原因を解決します。
*   **Seed Data Determinism (固定シード)**:
    *   **Law**: 再現性のあるテスト環境を構築するため、テストデータ（Seed）は乱数を使わず、**固定ID・固定値** を使用することを義務付けます。「毎回結果が変わる」テストはテストではありません。
    *   **Snapshot**: タイムスタンプに依存するテストも、`FakeTimer` 等を用いて時間を固定してください。

## 3. 実機テストと互換性 (Real Device & Compatibility)
*   **実機義務化 (Mandatory Real Device Testing)**:
    *   シミュレーターは完璧ではありません。リリース前には必ず物理デバイス（iOS/Android）で動作確認を行います。
    *   **TestFlight / Internal App Sharing**: 開発チーム全員が実機でドッグフーディングを行い、UXの違和感を検出します。
*   **フラグメンテーション対策**:
    *   **Android**: 主要メーカー（Samsung, Pixel, Xiaomi）や異なるOSバージョンでの動作を、BrowserStackやAWS Device Farmを用いて確認します。
    *   **ネットワーク**: オフライン、3G（低速）、機内モードからの復帰など、不安定なネットワーク環境での挙動をテストします。
*   **手動検証プロトコル (Manual Verification Protocol)**:
    *   機能実装完了時には、以下の観点で検証を行う義務があります。
    *   **Verification Checklist (必須確認項目)**:
        *   **Happy Path**: 正常系が動くか。
        *   **Edge Cases**: データ0件、最大文字数、通信エラー時の挙動。
        *   **Cross-Device**: PC (Chrome) と Mobile (iOS Safari実機) での表示崩れ。特にiOSの `100vh` 問題とセーフエリア。
        *   **Role Access**: 未ログイン、一般ユーザー、管理者での権限分離が正しく機能しているか。
        *   **API Security**: `x-api-key` なしのリクエストが拒否されること（Public）、`Authorization: Bearer` (User) では許可されること（Native Bypass）の確認。
        *   **Natural Scrolling**: 画面最下部に意図しない「謎の余白」がないか、二重スクロールが発生していないか。

## 4. 再発防止 (Fix Twice Principle)
*   **Double Fix**:
    *   バグを修正する際は、「そのバグを直す (Fix Once)」だけでなく、「二度と同じバグが起きない仕組み（Lint追加、型厳格化、テスト追加）を作る (Fix Twice)」までをワンセットとします。
*   **The Regression Ban Protocol (Zero Recurrence Mandate)**:
    *   **Law**: 一度発生し修正されたバグが、後のバージョンで再発（Regression）することをエンジニアリングにおける「最大の失態」と定義します。
    *   **Action**: 
        1. **Visibility**: 再発したバグを修正する際は、必ず `task.md` や `walkthrough.md` に「再発した事実」と「なぜ前回の仕組みで防げなかったのか」という反省を明記してください。
        2. **Hardening**: 単なるコード修正で終わらせず、そのバグを物理的に捕捉する自動テスト（Regression Test）を追加することを、タスク完了の絶対条件とします。

## 5. リリース判定 (Release Criteria)
*   **ブロッカー (Blockers)**:
    *   P0（クリティカル）およびP1（メジャー）のバグが残っている状態でのリリースは**絶対禁止**です。
    *   **0 Warnings**: コンソールやビルドログにWarningが残っている状態でのリリースも禁止します。
*   **段階的ロールアウト (Phased Rollout)**:
    *   全ユーザーに一度に公開せず、1% → 5% → 20% → 100% と段階的に公開範囲を広げ、予期せぬ不具合の影響を最小限に抑えます。

## 5. 究極のユーザー視点 (Ultimate User Perspective)
*   **おばあちゃんテスト (The Grandmother Test)**:
    *   **基準**: 「ITに詳しくない祖母でも、説明なしで使えるか？」を常に自問します。
    *   **直感性**: マニュアルが必要なUIは「バグ」とみなします。
*   **Bug Bash (全員参加テスト)**:
    *   メジャーリリース前には、エンジニアだけでなく、デザイナーやPMも含めた全員で「Bug Bash（バグ出し大会）」を開催し、多様な視点でエッジケースを洗い出します。

## 7. CI/CD環境認識 (Environment Awareness)

### 7.1. The Clean Room Mirage Protocol (CI/CD環境ギャップ認識)
*   **Law**: CIは「空のDB（Clean Room）」でテストするため、**データ依存の制約違反（重複データ、外部キー参照先の不在等）を検知できません**。一方、本番デプロイ（CD）は「汚れたDB」で実行されます。この乖離が「CI Green だけど本番デプロイ失敗」の主犯です。
*   **Action**:
    1.  **Data-Aware Migration**: DML（`UPDATE`, `INSERT`）を含むマイグレーションは、本番データとの衝突を想定した防衛的コード（`DO` ブロック, `ON CONFLICT`, 重複削除ロジック）で記述してください。
    2.  **No Blind Trust**: 「ローカルで動いた」「CIが通った」は免罪符になりません。本番データ構造を想像力または参照で補完してください。
    3.  **Staging Verification**: 可能な限り、本番に近いデータを持つステージング環境でマイグレーションを事前検証してください。
*   **Rationale**: CIの「全グリーン」は「クリーンルームでの成功」に過ぎません。本番環境の複雑さ（既存データ、並行アクセス）を忘れた時、デプロイ失敗は確実に訪れます。

### 7.2. The RFC 7807 Error Response Standard（標準エラーレスポンス）
*   **Law**: 全てのAPIエラーレスポンスは、[RFC 7807 (Problem Details for HTTP APIs)](https://www.rfc-editor.org/rfc/rfc7807) に準拠した構造化フォーマットで返却してください。単純な文字列エラー（`"Something went wrong"`）は禁止します。
*   **Action**:
    1.  **Structured Format**: エラーレスポンスには最低限 `type`（エラー種別URI）、`title`（人間可読な要約）、`status`（HTTPステータスコード）、`detail`（具体的な説明）を含めてください。
    2.  **Machine-Readable**: AIエージェントや外部SaaSが自律的にエラーを解析・対処できるよう、`type` フィールドでエラーの種類を一意に識別可能にしてください。
    3.  **Consistent Handler**: エラーレスポンスの生成を共通ヘルパー関数（`errorResponse()` 等）に集約し、フォーマットの一貫性を保証してください。
*   **Rationale**: 非構造化エラーは「AIに対する非協力的な設計」です。生成AI時代において、APIの利用者は人間だけではありません。機械可読なエラーフォーマットは、自動リトライ、エラー分類、インシデント対応の自動化を可能にします。

## 8. スキーマ同期と診断 (Schema Synchronization & Diagnostics)

### 8.1. The Full-Stack Schema Synchronicity Protocol（全層スキーマ同期義務）
*   **Law**: データモデル（テーブル構造、設定値のスキーマ等）を変更する場合、**Migration → Schema/Type定義 → DTO → Action/Service → UI**の全レイヤーを**一括で修正**し、1回のコミットでZero Defect状態を維持してください。古い参照が1箇所でも残る「部分更新コミット」は禁止です。
*   **Action**:
    1.  **Vertical Slice**: スキーマ変更時は、「縦に切る（Vertical Slice）」アプローチで全レイヤーを一度に変更してください。「まずDBだけ」「次にAPIだけ」という水平分割は中間状態を生み、型エラーやランタイムクラッシュを招きます。
    2.  **Type-Driven Discovery**: 型定義（TypeScript Interface / Zod Schema等）を最初に変更すれば、コンパイラが「古い参照」を全て自動検出してくれます。型エラーがゼロになるまで修正を続けてください。
    3.  **Search & Destroy**: 型システムでは検出できない参照（動的キー、JSONパス、テスト内のフィクスチャ等）は、プロジェクト全体でGrepし、手動で修正してください。
*   **Rationale**: 「後で直す」は忘却のシノニムです。スキーマ変更が全レイヤーに伝播するまでの間、システムは「型が正しいのにランタイムで壊れる」という最も診断困難な状態に陥ります。

### 8.2. The Phantom File Awareness Protocol（ファントムファイル検知義務）
*   **Law**: ビルドエラーが「存在しないファイル」や「行番号の不一致」を示す場合、それはバンドラーやトランスパイラが解決した**re-export先やBarrelファイル経由の実体ファイル**を指している可能性があります。エラーメッセージのファイル名を鵜呑みにせず、**エラー行のコード内容でGrepして真犯人を特定**してください。
*   **Action**:
    1.  **Content Grep**: ビルドエラーの「エラー行のコード内容」で `grep -rn "エラー内容" src/` を実行し、実際にそのコードが存在するファイルを特定してください。
    2.  **Import Chain Trace**: エラーが示すファイルが `index.ts`（Barrel File）の場合、そこからre-exportされている各ファイルを個別に確認してください。
    3.  **Source Map Awareness**: ミニファイ・バンドル後のエラーメッセージは元のソースとの対応が崩れている場合があります。Source Mapを有効にした状態でビルドエラーを確認してください。
*   **Rationale**: モジュールバンドラー（Webpack, Turbopack, esbuild等）は複数のファイルを結合・変換するため、エラーメッセージが示すファイルパスや行番号が、開発者が編集すべき「本当のファイル」と一致しないことがあります。この「ファントムファイル」問題を認識していないと、存在しないファイルを延々と探し続ける時間の浪費が発生します。

### 8.3. The Vertical Synchronization Protocol（垂直同期プロトコル）
*   **Law**: フォームフィールドの欠落・不整合が疑われる場合、**DB Schema → DTO → Gateway/Service → UI Interface（フォーム定義）**の全レイヤーを**垂直に検証**しなければなりません。UIにのみ存在しDBに存在しない「幽霊フィールド」は即時排除してください。
*   **Action**:
    1.  **Top-Down Trace**: 問題のフィールドについて、DBテーブル定義 → DTO型定義 → Gateway/ServiceのSelect Spec → UIのフォーム定義（`defaultValues` / `register` / `Controller`）の順に存在と命名の一貫性を確認してください。
    2.  **Ghost Field Detection**: UIインターフェースに定義されているがDBスキーマに存在しないフィールドは「幽霊フィールド（Phantom Field）」です。将来のために予約した未実装フィールドがフォーム監査（Rule 35.100等）で「不足」と誤認される原因となるため、UIインターフェースから削除してください。
    3.  **Bottom-Up Verification**: DBに追加された新しいカラムが、DTO、Gateway、UIの全レイヤーに伝播していることを確認してください。どこか1つでも欠落があると、「保存は成功するが表示されない」または「表示されるが保存されない」不整合が発生します。
    4.  **Naming Consistency**: 全レイヤーでフィールド名（プロパティ名）が完全に一致していることを確認してください。微妙な命名の揺れ（例: `dog_description` vs `description_dog`）はサイレントなマッピング失敗の原因です。
*   **Rationale**: 現代のWebアプリケーションは複数のレイヤー（DB → 型定義 → Service → UI）でデータが流通します。1つのレイヤーでの変更が他のレイヤーに伝播しないと、型チェックが通っても実行時にデータが消失・表示不能になる「垂直同期不整合」が発生します。これはビルドエラーでは検出されず、手動の垂直走査でのみ発見可能です。

### 8.4. The Zero Future-Use Code Mandate（将来用コード禁止）
*   **Law**: 「将来使うかもしれない」コード（未使用の変数、インポート、関数、コンポーネント、型定義）のコミットを禁止します。コードベースに存在する全てのコードは、**現在使用されている**ものでなければなりません。
*   **Action**:
    1.  **YAGNI Enforcement**: "You Aren't Gonna Need It" を徹底し、未使用コードは即時削除してください。Git履歴から復元可能であるため、「念のため残す」は不要です。
    2.  **Lint Guard**: `no-unused-vars`, `no-unused-imports` 等のESLintルールを `error` レベルに設定し、CIで物理的にブロックしてください。
    3.  **eslint-disable Prohibition**: `// eslint-disable-next-line` の使用は原則禁止です。やむを得ない場合は理由とIssue番号を併記し、コードレビューでの承認を必須としてください。
    4.  **Dead Code Scan**: 四半期ごとにデッドコードスキャンツール（`ts-prune`, `knip` 等）を実行し、未使用のエクスポートを検出・削除してください。
*   **Rationale**: 未使用コードは「壊れた窓」の典型であり、コンパイラの誤診を招き、新規参画者の理解を妨げ、バンドルサイズを肥大化させます。将来必要になれば、そのときに必要な仕様で書き直す方が、古い想定のコードを修正するよりも常に安全かつ迅速です。

### 8.5. The Production Build Verification Protocol（本番ビルド検証義務）
*   **Law**: 開発サーバー（`dev` モード）が正常に動作することは、コードの正しさを**一切保証しません**。プルリクエスト作成前および機能完了宣言前に、`npm run build`（または同等の本番ビルドコマンド）を**必ず通過**させてください。
*   **Action**:
    1.  **Build Before PR**: プルリクエストを作成する前に、ローカルで本番ビルドを実行し、エラーゼロを確認してください。「CIが落ちたら直す」は許容されません。
    2.  **Dev ≠ Prod**: 開発サーバーはホットリロードのために多くのエラーを隠蔽します（型チェックのスキップ、Tree Shakingの省略、Strict Modeの無効化等）。本番ビルドでのみ発現するエラーが常に存在することを前提としてください。
    3.  **CI Enforcement**: CI/CDパイプラインにおいて、型チェック (`tsc --noEmit`) → Lint (`eslint --max-warnings=0`) → ビルド (`npm run build`) の3段階ゲートを必須とします。いずれか1つでも失敗した場合、マージをブロックしてください。
    4.  **Build Time Budget**: ビルド時間が5分を超えた場合はパフォーマンス調査を開始し、10分を超えた場合は速度改善を最優先タスクとして対処してください。
*   **Rationale**: 「dev環境では動いていました」は、本番障害時の言い訳として最も頻出し、最も価値のない報告です。開発サーバーと本番ビルドの挙動差異は構造的なものであり、ビルド検証を省略するワークフローは「障害の予約」と同義です。
