# 40. AI実装とUX戦略 (AI Implementation & UX Strategy)

## 4. 危機管理 (Crisis Management)
*   **The Red Button Protocol (AI Kill Switch)**:
    *   **Risk**: プロンプトインジェクションによる「ヘイトスピーチ大量生成」や、APIループによる「クラウド破産」の発生。
    *   **Solution**: コードの再デプロイを待たずに、一瞬でAI機能を全停止できる「緊急停止スイッチ (Global Kill Switch)」を実装してください。Edge ConfigやDBフラグ (`ai_enabled: false`) で制御します。

## 5. AI FinOps (財務戦略とリソース管理)
*   **The 30% Profitability Rule**:
    *   AI機能の原価（トークン代）は、いかなる場合もプラン収益の **30%** を超えてはなりません。
*   **Model Selection Protocol (Cost/Performance)**:
    *   **The Model Router Protocol (Tiered Architecture)**:
        *   **Law**: コード内で特定のモデルID（例: `"gemini-1.5-flash"`）をハードコーディングすることを禁止します。
        *   **Action**: 必ず `Tier`（例: `Tier.FAST`, `Tier.SMART`, `Tier.VISION`）という抽象化レイヤーを介してモデルを呼び出す「ルーター機能」を実装し、将来のモデル変更や価格改定時に一箇所で対応できるようにしてください。
    *   **Principle**: 常に「コスト」「速度」「精度」のバランスが最適化された最新モデルを選定します。
    *   **Current Standard**: 現時点では **Gemini 2.0 Flash** を「圧倒的なコストパフォーマンス」の観点から標準採用します。Thinkingが必要な場合のみ上位モデル (`Gemini 2.0 Flash Thinking` 等) を検討します。
    *   **Quota & Tiering Standards (Tier別制限基準)**:
    *   **Principle**: 「無制限」はUI上のメタファーに留め、内部的には厳格なキャップ（上限）を設けます。以下の基準をベースラインとします。
    *   **Reference Limits (Example: Standard SaaS Model)**:
        *   ※以下の数値は標準的なSaaSモデルの参考例です。プロジェクトの採算性に応じて調整してください。
        *   **Free**: Chat 5回/日, Vision 0回.
        *   **Standard**: Chat 30回/日, Thinking 3回. (ROI重視)
        *   **Premium**: Chat 100回/日, Thinking 10回. (満足度重視)
    *   **Vision AI Standards (Thinking Ban)**:
        *   **Law**: "Thinking Mode"はOCRのような即時認識タスクには遅すぎて不適切です。ユーザーの期待値ギャップ（Expectation Gap）を防ぐため、画像認識には `gemini-2.0-flash` を使用し、Thinkingモデルの使用を禁止します。
    *   **Over-Limit**: 上限到達時は、ポイント課金 (Pay-as-you-go) などで柔軟に対応します。
    *   **The AI Tier Metering Protocol (利用量計測と課金連携)**:
        *   **Law**: 有料プランでAI機能に利用制限を設ける場合、利用回数は**サーバーサイドで厳格に計測・記録**し、課金システムと連携させます。
        *   **Action**:
            1.  **Atomic Counting**: AI API呼び出し成功時、トランザクション内で `usage_counts` テーブル等にカウントを記録します。レスポンス受信前にカウントを進めることで、エラー時の不公平を回避します。
            2.  **Graceful Denial**: 上限到達時は、APIエラーではなく、「本日の利用回数に達しました。明日リセットされます」等のユーザーフレンドリーなUIで通知します。
            3.  **No Bypass**: クライアントからの直接API呼び出しを許可せず、全てサーバー経由とすることで、計測バイパスを物理的に阻止します。

## 6. マルチモーダルAIとエッジAI (Multimodal & Edge AI)
*   **技術スタック (Tech Stack)**:
    *   **Web**: **TensorFlow.js** または **ONNX Runtime Web** を使用し、ブラウザ内で推論を完結させます。
    *   **Mobile**: **CoreML** (iOS) および **TensorFlow Lite** (Android) を使用し、ネイティブパフォーマンスとプライバシーを確保します。
*   **画像解析 (Vision)**:
    *   **プライバシー**: 画像解析は可能な限りクライアントサイド（オンデバイスAI）で行い、サーバーへの送信を最小限にします。「生画像データ」はデバイス外に出さないのが理想です。
    *   **アクセシビリティ**: 解析結果は必ず `alt` テキストや音声読み上げに対応させます。
*   **音声認識 (Voice)**:
    *   **レイテンシ**: 音声入力のフィードバック（波形アニメーション等）は即座に行い、録音されていることを視覚的に伝えます。
    *   **誤認識対策**: 重要なアクション（送金、削除）は音声のみで完結させず、必ず画面上での確認ステップを挟みます。
*   **Optical Data Entry Strategy (OCR/Vision)**:
    *   **Optical Archive**: **請求書や公的証明書**などの物理ドキュメントは、Vision AI (GPT-4o/Gemini) を通じて構造化データ（日付、品目、金額）に自動変換します。ユーザーには「入力フォーム」ではなく「カメラ」を提供するUXを目指します。

## 7. 評価と改善 (Evaluation & Improvement)
*   **PromptOps Workflow**:
    *   **Git-Based Versioning**: プロンプト変更はPRベースで行います。「誰が、いつ、なぜ変えたか」を追跡可能にします。
    *   **Regression Testing**: 変更時は「正解データセット (Golden Dataset)」を用いた回帰テストを行い、品質劣化を防ぎます。
*   **Automated Evaluation (LLM-as-a-Judge)**:
    *   回答品質の判定には、人間だけでなく上位モデルを「審判」として用いる自動評価を導入し、デプロイ基準とします。
*   **The Model Switch Protocol (モデル切替手順)**:
    *   **Law**: AIモデルの世代交代は頻繁に発生し、切替時に品質劣化が起きるリスクがあります。モデル変更は以下の4段階プロセスを必ず経由させてください。
    *   **Step 1 (Staging Test)**: 新モデルをステージング環境のみで有効化し、Golden Dataset で精度を検証します。
    *   **Step 2 (Shadow Mode)**: 本番環境で旧モデルと新モデルを同時実行（Shadow Traffic）し、レスポンスの差分を記録します。比較期間は最低 **48時間** を推奨します。
    *   **Step 3 (Canary Release)**: ユーザーの一部（例: 10%）に新モデルを配信し、エラー率・満足度をモニタリングします。
    *   **Step 4 (Full Rollout)**: 問題なければ全ユーザーに展開します。
    *   **Rollback**: 各ステップにおいて即時ロールバック（旧モデルへの切り替え）が可能な状態を維持してください。環境変数（例: `AI_MODEL_VERSION`）で制御することを推奨します。
