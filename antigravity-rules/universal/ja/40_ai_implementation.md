# 40. AI実装とUX戦略 (AI Implementation & UX Strategy)

## 1. AI UXの原則 (AI UX Principles - "Zero Latency Perception")
*   **ストリーミング・ファースト (Streaming First)**:
    *   **ルール**: AIの応答待ち時間は「体感ゼロ」でなければなりません。ローディングスピナー（グルグル）は敗北です。
    *   **実装**: サーバーからのレスポンスを待たず、1トークンずつリアルタイムに表示（ストリーミング）します。
*   **楽観的UI (Optimistic UI)**:
    *   **即時反応**: ユーザーが送信ボタンを押した瞬間、AIの処理完了を待たずに、UI上では「成功」として扱います（チャットバブルの即時表示など）。
    *   **バックグラウンド処理**: 実際の処理はバックグラウンドで行い、万が一失敗した場合のみ、ユーザーに優しく通知し、リトライを促します。
*   **状態の可視化 (State Visibility)**:
    *   AIが「何をしているか」を透明化します。
    *   `Thinking...` (思考中), `Searching...` (検索中), `Generating...` (生成中) といったステータスを細かく表示し、ユーザーの不安を取り除きます。
*   **AI Psychology (Satisfaction > Speed)**:
    *   **Thinking Visualization**: 長考する場合は単なるスピナーではなく、「思考プロセス」を可視化するアニメーションを表示し、待ち時間を「期待感」に変えます。
    *   **The High Cost Metaphor**: 回数制限を表示する際は、「ケチな制限」ではなく「高度なエネルギーを使い切った（Daily Energy Limit）」等、機能の価値を高めるメタファーを使用します。

## 2. AI倫理と安全性 (AI Ethics & Safety)
*   **安全設定 (Safety Settings)**:
    *   **フィルタリング**: Gemini/OpenAIの安全設定（ハラスメント、ヘイトスピーチ、性的なコンテンツ等）は、原則として「最高レベル」に設定します。
    *   **脱獄対策 (Jailbreak Policy)**: プロンプトインジェクション攻撃を防ぐため、システムプロンプト内でユーザー入力を厳格に区別する方針を徹底します。(実装はSec.3参照)
*   **Medical Disclaimer Protocol (医療免責プロトコル)**:
    *   **No Diagnosis Mandate (診断禁止)**: AIによる「診断 (Diagnosis)」「投薬指示 (Prescription)」「予後予測 (Prognosis)」は、**医療法や関連専門法**に抵触するため絶対禁止です。
    *   **Emergency Response**: 危険キーワード（`血`, `痙攣`, `意識がない` 等）を検知した場合、生成を中止し、直ちに「緊急事態の可能性があります。病院へ連絡してください」というルールベースのアラートを表示します。
*   **Hallucination Mitigation (ハルシネーション対策)**:
    *   **Mandatory Disclaimer**: AI回答には「※AI情報は不正確な可能性があります。正確な判断は専門機関へ」等の免責を常時表示します。
    *   **Grounding & Citations**: 可能であれば、回答の根拠となるソース（引用元/DB情報）を提示します（RAGの場合）。
*   **Privacy & Bias**:
    *   **PII Scrubbing**: 外部LLMへ送信するプロンプトには、個人情報（電話番号、氏名）を含めてはなりません。正規表現等で送信前にマスク処理 (`[連絡先削除]`) を行います。
*   **Reporting**:
    *   生成AIアプリには、不適切なコンテンツをユーザーが通報・ブロックできる機能を必ず実装します（Google Play 2025要件）。

## 3. 技術アーキテクチャ (Technical Architecture)
*   **Private Relay & Execution Pattern**:
    *   **No API Keys on Client**: APIキー (`NEXT_PUBLIC_`) のクライアント露出は厳禁です。全てのAI処理は、Server ActionsまたはRoute Handler (`process.env.KEY`) を経由します。
    *   **Streaming**: チャット等の対話機能には **Vercel AI SDK (Streaming)** を必須とし、可能な限り **Edge Runtime** で実行してコールドスタートを回避します。
    *   **Async Offloading**: 画像解析など数秒以上かかる重い処理は、Vercelのタイムアウトを避けるため、**Supabase Edge Functions + pgmq** (非同期キュー) にオフロードします。
*   **Context Window Management (トークン最適化)**:
    *   **Token Saving**: 無限に会話履歴を送るのではなく、要約（Summarization）や重要なコンテキストのみを抽出して送信します。
    *   **Cost Optimization**: 入力トークン数を常に監視し、不要な情報はプロンプトから削除します。
*   **PromptOps (Engineering Lifecycle)**:
    *   **Code-as-Prompts**: プロンプトはDBテキストではなく、Git管理下のコード (`src/lib/prompts/*.ts`) として定数定義し、レビュー対象とします。
    *   **Structured Output**: AIからのレスポンスは、可能な限りJSONモードを使用して構造化し、パースエラーを防ぎます。
    *   **Jailbreak Defense**: ユーザー入力を「信頼できない外部入力」として扱い、システム命令の上書きを無効化するガードレールを設置します。
    *   **Grounding & Citations**: 店舗情報や価格などの事実は必ずDBの確定情報と照合（Grounding）し、可能であれば引用元（Source）を提示します。
*   **Caching**:
    *   同じ入力に対する回答はキャッシュし、コストとレイテンシを削減します（Semantic Caching）。

## 4. AI FinOps (財務戦略とリソース管理)
*   **The 30% Profitability Rule**:
    *   AI機能の原価（トークン代）は、いかなる場合もプラン収益の **30%** を超えてはなりません。
*   **Model Selection Protocol (Cost/Performance)**:
    *   **Principle**: 常に「コスト」「速度」「精度」のバランスが最適化された最新モデルを選定します。
    *   **Current Standard**: 現時点では **Gemini 2.0 Flash** を「圧倒的なコストパフォーマンス」の観点から標準採用します。Thinkingが必要な場合のみ上位モデル (`Gemini 2.0 Flash Thinking` 等) を検討します。
    *   **Quota & Tiering Standards (Tier別制限基準)**:
    *   **Principle**: 「無制限」はUI上のメタファーに留め、内部的には厳格なキャップ（上限）を設けます。以下の基準をベースラインとします。
    *   **Reference Limits (Example: Standard SaaS Model)**:
        *   ※以下の数値は標準的なSaaSモデルの参考例です。プロジェクトの採算性に応じて調整してください。
        *   **Free**: Chat 5回/日, Vision 0回.
        *   **Standard**: Chat 30回/日, Thinking 3回. (ROI重視)
        *   **Standard**: Chat 30回/日, Thinking 3回. (ROI重視)
        *   **Premium**: Chat 100回/日, Thinking 10回. (満足度重視)
    *   **Vision AI Standards (Thinking Ban)**:
        *   **Law**: "Thinking Mode"はOCRのような即時認識タスクには遅すぎて不適切です。ユーザーの期待値ギャップ（Expectation Gap）を防ぐため、画像認識には `gemini-2.0-flash` を使用し、Thinkingモデルの使用を禁止します。
    *   **Over-Limit**: 上限到達時は、ポイント課金 (Pay-as-you-go) などで柔軟に対応します。

## 5. マルチモーダルAIとエッジAI (Multimodal & Edge AI)
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

## 6. 評価と改善 (Evaluation & Improvement)
*   **PromptOps Workflow**:
    *   **Git-Based Versioning**: プロンプト変更はPRベースで行います。「誰が、いつ、なぜ変えたか」を追跡可能にします。
    *   **Regression Testing**: 変更時は「正解データセット (Golden Dataset)」を用いた回帰テストを行い、品質劣化を防ぎます。
*   **Automated Evaluation (LLM-as-a-Judge)**:
    *   回答品質の判定には、人間だけでなく上位モデルを「審判」として用いる自動評価を導入し、デプロイ基準とします。
