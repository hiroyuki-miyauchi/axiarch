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
