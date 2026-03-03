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

## 2. AI Governance, Ethics & Safety (AI統治と倫理・安全性)
*   **安全設定 (Safety Settings)**:
    *   **フィルタリング**: Gemini/OpenAIの安全設定（ハラスメント、ヘイトスピーチ、性的なコンテンツ等）は、原則として「最高レベル」に設定します。
    *   **脱獄対策 (Jailbreak Policy)**: プロンプトインジェクション攻撃を防ぐため、システムプロンプト内でユーザー入力を厳格に区別する方針を徹底します。(実装はSec.3参照)
*   **Medical Disclaimer Protocol (医療免責プロトコル)**:
    *   **No Diagnosis Mandate (診断禁止)**: AIによる「診断 (Diagnosis)」「投薬指示 (Prescription)」「予後予測 (Prognosis)」は、**医療法や関連専門法**に抵触するため絶対禁止です。
    *   **Emergency Response**: 危険キーワード（`血`, `痙攣`, `意識がない` 等）を検知した場合、生成を中止し、直ちに「緊急事態の可能性があります。病院へ連絡してください」というルールベースのアラートを表示します。
    *   **Disclaimer Placement Strategy (免責配置戦略)**: 免責表示はAI回答の末尾だけでなく、**入力欄付近**や**初回利用時のモーダル/オンボーディング**にも配置し、ユーザーが「見落とさなかった」と言えない状態を構築してください（UXによる法的防御）。
*   **Hallucination Mitigation (ハルシネーション対策)**:
    *   **Mandatory Disclaimer**: AI回答には「※AI情報は不正確な可能性があります。正確な判断は専門機関へ」等の免責を常時表示します。
    *   **The Triple Write RAG Protocol (Clean Data Source)**:
        *   **Law**: RAG（検索拡張生成）の参照ソースには、CMS憲法 (`34`) で義務付けられた **「Triple Write されたプレーンテキスト同期データ」** を必ず使用してください。
        *   **Reason**: HTMLタグを含むノイズだらけのデータをAIに読ませることは、トークンの無駄遣いであり、回答精度の低下を招きます。
    *   **Grounding & Citations**: 可能であれば、回答の根拠となるソース（引用元/DB情報）を提示します（RAGの場合）。
*   **The Hallucination Tiered Disclaimer Protocol (段階的免責)**:
    *   **Law**: ハルシネーション（事実と異なる情報の生成）のリスクはコンテキストの種類によって異なります。一律の免責ではなく、リスクレベルに応じた段階的な免責対応を義務付けます。
    *   **Mandate**:
        | リスクレベル | コンテキスト例 | 免責対応 |
        |:---|:---|:---|
        | **Critical** | 医療・法律・金融等の専門情報 | 免責を**必ず**表示。「専門家にご相談ください」を自動付与 |
        | **High** | 営業時間・価格・在庫等の事実情報 | DB内データとの照合（Grounding）を必須化。照合不能なら「確認が取れていません」と表示 |
        | **Medium** | 一般的なアドバイス・推奨 | 「参考情報です」ラベルを表示 |
        | **Low** | 雑談・エンタメ | ラベル不要（ただし有害性チェックは適用） |
*   **Privacy & Bias**:
    *   **PII Scrubbing**: 外部LLMへ送信するプロンプトには、個人情報（電話番号、氏名）を含めてはなりません。正規表現等で送信前にマスク処理 (`[連絡先削除]`) を行います。
    *   **The Fairness Protocol (Bias Mitigation)**:
        *   **Law**: 特定の属性（人種、性別、または犬種等の特定カテゴリ）に対する、統計的根拠のない偏見や差別的な回答を生成しないよう、システムプロンプトで明示的に制御します。
        *   **Action**: 「危険である」「劣っている」といったバイアスを含む形容詞の使用を監視し、中立的な表現を強制します。
*   **Reporting**:
    *   生成AIアプリには、不適切なコンテンツをユーザーが通報・ブロックできる機能を必ず実装します（Google Play 2025要件）。
*   **The AI Generated Content Labeling Protocol (AI生成コンテンツラベリング義務)**:
    *   **Law**: AIが生成・補助したコンテンツ（テキスト、画像解析結果、レコメンデーション等）には、その出自を明示するラベルを常時表示しなければなりません。ラベルの非表示・隠蔽・極小化は禁止です。EU AI Act および各国の AI 規制ガイドラインの原則に準拠してください。
    *   **Action**:
        1.  **Chat Label**: AIチャットの回答には `🤖 AIが回答しました` 等のラベルを常時表示します。
        2.  **Analysis Label**: AI画像解析（OCR等）の結果には「AIが読み取った内容です。正確性をご確認ください」と表示します。
        3.  **DB Flag**: AI生成コンテンツを保存する際は、`is_ai_generated: boolean` カラム（デフォルト: `false`）を使用し、データレベルでも出自を追跡可能にしてください。
*   **The Citation Display Protocol (引用元表示義務)**:
    *   **Law**: AIが外部情報（DB内データ、ナレッジベース記事等）を参照して回答を生成する場合、「どの情報を根拠にしたか」の透明性がユーザーの信頼とサービスの法的防御に直結します。以下の3段階ラベルで情報の出自を明示してください。
    *   **Mandate**:
        | ソース種別 | ラベル例 | 適用条件 |
        |:---|:---|:---|
        | **RAG引用** | `📎 参考情報: [ソース名](URL)` | RAGで取得した外部情報に基づく回答 |
        | **DB確定データ** | `✅ 確認済み情報` | DB内の確定データ（営業時間、住所等）に基づく回答 |
        | **AI推論** | `💡 AI参考回答` | AIの推論・一般知識に基づく回答 |
    *   **No Source, No Claim**: 参照元がない事実情報（価格、日時、法規制等）を断定的に述べることを禁止します。
*   **The AI Governance Committee Protocol (AIガバナンス委員会)**:
    *   **Law**: AI技術の進化とリスクの増大に伴い、技術的判断だけでなくビジネス・法務・倫理の観点を統合した意思決定が必要です。事業規模が一定段階（例: シリーズA以降、または有料ユーザー数が一定規模に到達）に達した時点で、以下の役割を含む**AIガバナンス委員会**を設置してください。
    *   **Required Roles**:
        *   技術責任者（CTO / テックリード）
        *   法務・コンプライアンス担当
        *   ユーザー代表（CS / UXリサーチャー）
    *   **Scope**: モデル選定、プロンプト方針変更、新規AI機能のリスク評価、インシデント対応を審議します。
    *   **Cadence**: 四半期ごとのレビュー + 緊急時の臨時招集。
    *   **Cross-Reference**: Red Button Protocol (§4), Model Switch Protocol (§7)
*   **The AI-Generated Content Copyright Governance Protocol (AI生成コンテンツ著作権)**:
    *   **Law**: AI生成コンテンツの著作権は法的にグレーゾーンであり、各国の著作権法およびAI著作権ガイドラインに準拠した運用が必要です。以下の原則を遵守してください。
    *   **Mandate**:
        1.  **No Raw Publish**: AI生成テキストをそのまま公式コンテンツ（公開記事、マーケティング資料等）として掲載することを**禁止**します。人間による編集・検証・加筆を経たものだけが「公式コンテンツ」として扱われます。
        2.  **Image Risk Assessment**: AI生成画像を商用利用する場合は、学習データの著作権リスクを評価し、利用規約に免責事項を明記してください。
        3.  **DB Flag**: AI支援の有無をデータレベルで追跡するため、コンテンツテーブルに `is_ai_assisted: boolean` フラグ（デフォルト: `false`）を追加してください（AI Generated Content Labeling Protocol と連動）。
    *   **Cross-Reference**: AI Generated Content Labeling Protocol (§2)
*   **The User Data AI Training Opt-Out Protocol (ユーザーデータの学習利用制御)**:
    *   **Law**: ユーザーがサービス上で入力したデータ（チャット履歴、レビュー、検索ログ等）をAIモデルの改善・ファインチューニングに利用する場合、GDPR および各国の個人情報保護法（APPI等）の「目的外利用の禁止」原則に準拠した Opt-Out / Opt-In の仕組みが不可欠です。
    *   **Mandate**:
        1.  **Default Opt-Out**: ユーザーデータはAI学習に**利用しない（Opt-Out by Default）**をデフォルトとしてください。
        2.  **Explicit Opt-In**: 利用規約の同意とは別に、「AIの品質向上のためにデータを提供する」ことへの**明示的な同意**（チェックボックス等）を取得した場合のみ、匿名化の上で学習データとして利用可能とします。
        3.  **DB Flag**: ユーザーテーブルに `ai_training_opt_in: boolean`（デフォルト: `false`）カラムを設け、ユーザーごとに同意状態を管理してください。
        4.  **Right to Withdraw**: ユーザーはいつでも Opt-In を撤回でき、撤回後のデータは次回の学習バッチから除外しなければなりません。
        5.  **Anonymization**: 学習データとして利用する場合でも、PII（氏名、メールアドレス、位置情報）は**完全に除去**した上で使用してください（PII Scrubbing 適用）。
        6.  **Transparency**: プライバシーポリシーに「AIの品質向上目的でのデータ利用」について明記し、Opt-In / Opt-Out 設定画面への導線を設けてください。
    *   **Cross-Reference**: PII Scrubbing (§2), Data Minimization / Right to be Forgotten (61)

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
    *   **The Prompt Injection Defense Pattern (防御実装パターン)**:
        *   **Input Sanitization (入力サニタイズ)**: ユーザー入力に含まれる制御文字列（`###`, `````, `<|system|>`, `SYSTEM:` 等）をエスケープまたは除去します。入力テキストの最大長を制限し（例: 2,000〜4,000文字）、超過分は切り捨ててください。
        *   **Delimiter Strategy (デリミタ戦略)**: システムプロンプトとユーザー入力の境界を明確なデリミタで囲み、構造的に分離します。
            ```
            [SYSTEM INSTRUCTION - DO NOT MODIFY]
            {system_prompt}
            [END SYSTEM INSTRUCTION]

            [USER MESSAGE]
            {user_input}
            [END USER MESSAGE]
            ```
        *   **Output Validation (出力バリデーション)**: AI応答に以下が含まれる場合、フィルタリングして除去します。
            *   システムプロンプトのリーク（プロンプト本文の部分一致検出）
            *   個人情報（PII）パターン（PII Scrubbing のマスキング対象と同一）
            *   外部URL（ホワイトリスト外のドメイン）
        *   **Logging**: Prompt Injectionの疑いがある入力を検出した場合、`warn` レベルでログに記録し、管理者に通知します。
    *   **Grounding & Citations**: 店舗情報や価格などの事実は必ずDBの確定情報と照合（Grounding）し、可能であれば引用元（Source）を提示します。
    *   **The Fact-Check Standards Protocol (ファクトチェック基準)**:
        *   **Law**: AI応答が外部ファクト（営業時間、住所、価格等）を引用する場合、DB内の確定データとの照合を行い、不一致時は「情報が古い可能性があります」と注記してください。
        *   **Numeric Data Rule**: 数値データ（価格、距離、数量等）は、RAGソースまたはDBからの**直接引用のみ許可**し、AIによる計算・推測は**禁止**します。
    *   **The RAG Source Absence Protocol (RAGソース不在時の免責)**:
        *   **Law**: RAGで情報ソースを取得した場合はその参照元を明示してください（Citation Display Protocol参照）。ソースが取得できなかった場合は、「この情報は参考情報です。正確性を保証するものではありません」という免責文言を**自動付与**しなければなりません。
*   **Caching**:
    *   同じ入力に対する回答はキャッシュし、コストとレイテンシを削減します（Semantic Caching）。
    *   **The Semantic Caching Protocol (pgvector戦略)**:
        *   **Requirement**: `pgvector` を用いた「類似度検索キャッシュ」の実装を推奨します。閾値は **0.95以上** とし、完全一致に近い問答のみをキャッシュ返却します。
        *   **Benefit**: これにより、コスト削減だけでなく、レスポンスタイムを大幅に短縮し、UXを改善します。
    *   **The RAG Document Chunk Cache Protocol (RAGチャンクキャッシュ)**:
        *   **Law**: RAGで頻繁に参照されるドキュメントチャンクは、Embedding検索のたびにDBから取得するのではなく、**インメモリまたは短期キャッシュ**（推奨TTL: 1時間）に保持し、レイテンシとDB負荷を削減してください。
        *   **Invalidation**: ソースドキュメントが更新された場合は、対応するチャンクキャッシュを即時無効化してください。

### 3.1. The AI Destructive Command Ban (AIエージェント破壊的コマンド禁止)
*   **Law**: AIエージェントは、いかなる理由があっても `rm`, `git rm`, `git restore`（特定の復旧意図のないもの）等の**破壊的コマンド**を、ユーザーの明示的な許可なしに自律的に生成・実行してはなりません。
*   **Action**:
    1.  **Text Asset Immunity**: 特にドキュメント資産（仕様書、ルール定義、コード）の削除は「プロジェクトの記憶喪失」を招くため、技術的に可能であっても「禁止された操作」として自己検閲してください。
    2.  **Exception**: `.DS_Store` や `node_modules` の削除などの明白なクリーンアップタスクはこの限りではありませんが、テキスト資産（コード、ドキュメント）には適用されません。
*   **Rationale**: AIエージェントは「ファイルの整理」を「削除」と解釈して実行する傾向があり、意図しない資産消失を引き起こすリスクがあります。

### 3.2. The Human-in-the-Loop Protocol (AI Supervision Mandate)
*   **Law**: AIエージェントは過去のコンテキスト（チャット履歴）に基づいて回答するため、古い情報や誤った前提に固執する場合があります。ユーザー（人間）は、AIが誤った方向に進んでいると感じた場合、ためらわずに「それは違う」「前提が変わった」と指摘し、**コンテキストを修正する義務**を負います。
*   **Rationale**: AIの暴走を放置することは、監督者（人間）の怠慢です。AIは「道具」であり、操縦責任は常に人間にあります。間違った方向に進むAIを止めないことは、間違った結果を承認することと同義です。

## 4. 危機管理 (Crisis Management)
*   **The Red Button Protocol (AI Kill Switch)**:
    *   **Risk**: プロンプトインジェクションによる「ヘイトスピーチ大量生成」や、APIループによる「クラウド破産」の発生。
    *   **Solution**: コードの再デプロイを待たずに、一瞬でAI機能を全停止できる「緊急停止スイッチ (Global Kill Switch)」を実装してください。Edge ConfigやDBフラグ (`ai_enabled: false`) で制御します。
    *   **Drill Obligation**: Kill Switch が正常に動作し、UIが適切に「メンテナンス中」等のフォールバック表示に切り替わることを確認する**定期的な動作訓練**を実施してください。訓練は半年に1回以上を推奨します。動作しないKill Switchは存在しないのと同じです。

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
*   **The AI Cost Monitoring & Alerting Protocol (AIコスト監視とアラート)**:
    *   **Law**: AI機能のコストは「ユーザー数 × 平均利用回数 × トークン単価」で指数関数的に増大します。以下の監視体制を義務付けます。
    *   **Mandate**:
        1.  **Usage Tracking Table**: `ai_usage_tracking` テーブル等で日次・月次のトークン消費量を集計してください。
        2.  **Budget Alert**: 月次予算の**80%**に到達した時点で、Slack/メール等によるアラートを自動発火させてください。
        3.  **Cache Strategy**: AI回答キャッシュのTTLを適切に設定し（一般的な質問 → 24時間、個別データ依存 → キャッシュなし）、API呼び出し削減を図ります。
        4.  **RAG Token Optimization**: RAGでコンテキスト取得する際も、取得フィールドを最小化し（Select Spec適用）、プロンプトトークンを削減してください。

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
*   **The AI Data Entry Confirmation Protocol (AI入力確認義務)**:
    *   **Law**: AIが画像認識（OCR）、音声認識、自然言語解析等によって抽出・構造化したデータを、ユーザーの確認なしにデータベースへ直接書き込む（Auto-Save）ことを**禁止**します。AIの読み取り結果は常に「下書き（Draft）」として扱わなければなりません。
    *   **Action**:
        1.  **Draft-First**: AIが抽出したデータは、まず「下書き」または「確認画面」としてユーザーに提示してください。
        2.  **Human Confirmation Gate**: ユーザーが目視で内容を確認し、必要に応じて修正した上で、明示的に「保存」ボタンを押すフローを強制してください。
        3.  **No Silent Write**: AIの処理結果がバックグラウンドで自動的にDBに書き込まれる設計は、データ品質と信頼性を損なうため厳禁です。
    *   **Rationale**: AIの認識精度は100%ではなく、誤認識データがそのまま保存されると、ユーザーの信頼喪失とデータ汚染を招きます。「撮る → 確認する → 保存する」という安全なフローをユーザーに保証してください。
*   **The OCR Output PII Scrubbing Protocol (OCR出力PIIスクラビング義務)**:
    *   **Law**: Vision AI / OCRが証明書・請求書・公的文書等から情報を抽出・構造化する際、元ドキュメントに含まれる**サービス目的外のPII**（第三者の氏名、住所、電話番号等）は、構造化データとして保存せず、システム上で自動的に**破棄またはマスキング**しなければなりません。
    *   **Action**:
        1.  **Extraction Filter**: OCR/Vision AIの構造化出力パイプラインにおいて、保存対象フィールド（日付、品目、金額等）のみをホワイトリスト方式で抽出し、対象外のPIIフィールドはレスポンスから除外してください。
        2.  **Post-Processing Scrub**: ホワイトリスト方式で除外できない場合は、構造化後のデータに対してPII検出ロジック（正規表現等）を適用し、マスキング処理を実行してください。
        3.  **No Raw Storage**: OCR元画像の生テキスト全文をそのままDBに保存することを禁止します。保存対象は、PII除去済みの構造化データのみとしてください。
    *   **Rationale**: 証明書や請求書には、サービス運用に不要な第三者の個人情報（発行者の氏名・連絡先等）が含まれます。これらを無差別に保存することは、データ最小化原則（GDPR Art.5(1)(c)）に違反し、情報漏洩時の被害を不必要に拡大させます。
    *   **Cross-Reference**: PII Scrubbing (§2), PII Sensitivity Classification (60: §8.8.1), Data Minimization (60: §3)

## 7. 評価と改善 (Evaluation & Improvement)
*   **PromptOps Workflow**:
    *   **Git-Based Versioning**: プロンプト変更はPRベースで行います。「誰が、いつ、なぜ変えたか」を追跡可能にします。
    *   **The Prompt Versioning Naming Convention (プロンプトバージョニング命名規約)**:
        *   **Law**: プロンプトファイルには `v1_xxx.ts`, `v2_xxx.ts` のようにバージョン番号をファイル名に含めてください。これにより、変更履歴が一目で把握可能になります。
    *   **The Prompt A/B Testing Protocol (プロンプトA/Bテスト)**:
        *   **Law**: プロンプト改善時は旧バージョンを**削除せず**、feature flag（環境変数等）で切り替え可能な状態を維持してください。品質メトリクスで旧版と新版を比較し、改善が確認されてから旧版を非推奨（deprecate）にします。
    *   **Regression Testing**: 変更時は「正解データセット (Golden Dataset)」を用いた回帰テストを行い、品質劣化を防ぎます。
*   **Automated Evaluation (LLM-as-a-Judge)**:
    *   回答品質の判定には、人間だけでなく上位モデルを「審判」として用いる自動評価を導入し、デプロイ基準とします。
*   **The AI Output Quality Metrics Protocol (AI応答品質指標)**:
    *   **Law**: AI応答の品質を定量的に評価・改善するため、以下のメトリクスを定義し、定期的にレビューしてください。
    *   **Required Metrics**:
        | 指標 | 計測方法 | ベースライン目標 |
        |:---|:---|:---|
        | **ハルシネーション率** | RAGソースとの照合（サンプリング） | < 5% |
        | **ユーザー満足度** | 👍/👎 フィードバック比率 | > 80% 👍 |
        | **応答時間 (P95)** | ログ集計 | < 3,000ms |
        | **ガードレール発動率** | 拒否ログ集計 | モニタリングのみ |
    *   **Review Cycle**: 月次でメトリクスをレビューし、劣化傾向が見られる場合はプロンプト改善タスクを起票します。
*   **The Model Switch Protocol (モデル切替手順)**:
    *   **Law**: AIモデルの世代交代は頻繁に発生し、切替時に品質劣化が起きるリスクがあります。モデル変更は以下の4段階プロセスを必ず経由させてください。
    *   **Step 1 (Staging Test)**: 新モデルをステージング環境のみで有効化し、Golden Dataset で精度を検証します。
    *   **Step 2 (Shadow Mode)**: 本番環境で旧モデルと新モデルを同時実行（Shadow Traffic）し、レスポンスの差分を記録します。比較期間は最低 **48時間** を推奨します。
    *   **Step 3 (Canary Release)**: ユーザーの一部（例: 10%）に新モデルを配信し、エラー率・満足度をモニタリングします。
    *   **Step 4 (Full Rollout)**: 問題なければ全ユーザーに展開します。
    *   **Rollback**: 各ステップにおいて即時ロールバック（旧モデルへの切り替え）が可能な状態を維持してください。環境変数（例: `AI_MODEL_VERSION`）で制御することを推奨します。
*   **The Model Selection Bias Assessment Protocol (モデル選定バイアス評価)**:
    *   **Law**: LLMはトレーニングデータに起因するバイアスを内包しています。新しいAIモデルを導入する際は、以下のバイアス評価チェックリストを通過させてください。
    *   **Checklist**:
        | 評価項目 | 検証方法 | 合格基準 |
        |:---|:---|:---|
        | **カテゴリバイアス** | 複数カテゴリに対する同一質問の回答比較 | 特定カテゴリへの偏見的表現が0件 |
        | **地域バイアス** | 都市部/地方の同一シナリオでの回答比較 | 地域による不当な差別表現が0件 |
        | **言語品質** | ターゲット言語での自然さ・敬語の適切さ評価 | 不自然な翻訳調が5%未満 |
        | **安全性準拠** | 専門情報（医療・法律等）に関する質問への免責遵守 | 免責プロトコル準拠率100% |
    *   **Frequency**: 四半期ごと、またはモデル切替時に実施してください。
