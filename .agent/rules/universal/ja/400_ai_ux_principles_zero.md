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
    *   **The Semantic Caching Protocol (pgvector戦略)**:
        *   **Requirement**: `pgvector` を用いた「類似度検索キャッシュ」の実装を推奨します。閾値は **0.95以上** とし、完全一致に近い問答のみをキャッシュ返却します。
        *   **Benefit**: これにより、コスト削減だけでなく、レスポンスタイムを大幅に短縮し、UXを改善します。

### 3.1. The AI Destructive Command Ban (AIエージェント破壊的コマンド禁止)
*   **Law**: AIエージェントは、いかなる理由があっても `rm`, `git rm`, `git restore`（特定の復旧意図のないもの）等の**破壊的コマンド**を、ユーザーの明示的な許可なしに自律的に生成・実行してはなりません。
*   **Action**:
    1.  **Text Asset Immunity**: 特にドキュメント資産（仕様書、ルール定義、コード）の削除は「プロジェクトの記憶喪失」を招くため、技術的に可能であっても「禁止された操作」として自己検閲してください。
    2.  **Exception**: `.DS_Store` や `node_modules` の削除などの明白なクリーンアップタスクはこの限りではありませんが、テキスト資産（コード、ドキュメント）には適用されません。
*   **Rationale**: AIエージェントは「ファイルの整理」を「削除」と解釈して実行する傾向があり、意図しない資産消失を引き起こすリスクがあります。

### 3.2. The Human-in-the-Loop Protocol (AI Supervision Mandate)
*   **Law**: AIエージェントは過去のコンテキスト（チャット履歴）に基づいて回答するため、古い情報や誤った前提に固執する場合があります。ユーザー（人間）は、AIが誤った方向に進んでいると感じた場合、ためらわずに「それは違う」「前提が変わった」と指摘し、**コンテキストを修正する義務**を負います。
*   **Rationale**: AIの暴走を放置することは、監督者（人間）の怠慢です。AIは「道具」であり、操縦責任は常に人間にあります。間違った方向に進むAIを止めないことは、間違った結果を承認することと同義です。
