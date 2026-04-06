# 51. ユーザーサポートとカスタマーサクセス (User Support & Customer Success)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「**ユーザーの成功がプロダクトの成功である**」——サポートは"コストセンター"ではなく"バリュードライバー"として設計せよ。
> すべてのサポートインタラクションは、ユーザーの**Time-to-Value（価値実現時間）を最短化**し、**Effort（手間）を最小化**するために存在する。
> **AI Autonomous Resolution Rate ≥ 80%**（2026年目標）を掲げ、人間エージェントは高付加価値対応に集中せよ。
> 本ルールは `000_core_mindset.md` の優先順位階層（セキュリティ > UX > 収益性 > DX）に従う。
> **33パート・40セクション構成。**

---

## 目次

- Part I: サポート哲学・基本原則
- Part II: AIエージェントサポート戦略
- Part III: オムニチャネルサポート設計
- Part IV: チケット管理・SLA
- Part V: エスカレーション設計
- Part VI: セルフサービス・ナレッジベース
- Part VII: カスタマーサクセス戦略
- Part VIII: Customer Health Score
- Part IX: オンボーディング設計
- Part X: 解約防止・リテンション
- Part XI: VoC・フィードバックループ
- Part XII: NPS/CSAT/CES計測基準
- Part XIII: インタラクション設計（フォーム）
- Part XIV: 通知・チャネル設計
- Part XV: メールテンプレート・品質基準
- Part XVI: メール送信ガバナンス
- Part XVII: コミュニティ・フォーラム戦略
- Part XVIII: Trust & Safety
- Part XIX: サポートアクセシビリティ
- Part XX: サポートオペレーション・チーム
- Part XXI: サポートQA・品質管理
- Part XXII: サポートFinOps
- Part XXIII: サポート分析・可観測性
- Part XXIV: コンプライアンス・規制対応
- Part XXV: Voice AI & Conversational Support
- Part XXVI: ハイパーパーソナライゼーション戦略
- Part XXVII: デジタルカスタマーサクセス (Digital CS)
- Part XXVIII: CS Revenue Accountability
- Part XXIX: プロアクティブサポート設計
- Part XXX: カスタマージャーニーオーケストレーション
- Part XXXI: サポートナレッジマネジメント (KCS)
- Part XXXII: 多言語・グローバルサポート設計
- Part XXXIII: カスタマーエフォートスコア最適化
- Part XXXIV: サポートAI安全性・倫理基準
- Part XXXV: Outcome-Based Support Pricing
- Part XXXVI: ワークフォースマネジメント (WFM)
- Part XXXVII: サポート技術スタック設計
- Part XXXVIII: カスタマーアドボカシー・ロイヤルティ
- Part XXXIX: 将来展望・新興技術
- Part XL: 成熟度モデル・逆引き索引

---

## Part I: サポート哲学・基本原則

### 1.1. The Support-as-Value-Driver Principle（サポート＝バリュードライバー原則）
*   **Law**: サポートを「コストセンター」ではなく「バリュードライバー（価値創出の源泉）」として位置づけること。
*   **Metrics Mandate**: サポート組織のKPIに以下の**3軸**を必ず含めること。

    | 軸 | 指標例 | 目的 |
    |:---|:-------|:-----|
    | **効率性** | 初回応答時間、解決時間、Deflection Rate、AI Resolution Rate | オペレーション最適化 |
    | **品質** | CSAT、CES、NPS、QAスコア、FCR | ユーザー体験の保証 |
    | **ビジネスインパクト** | リテンション率、Expansion Revenue、Support-Influenced ARR、Churn Saved Revenue | 収益貢献の可視化 |

### 1.2. The Empathy & Efficiency Doctrine（共感と効率の両立原則）
*   **Zappos Style Empowerment（権限委譲）**:
    *   サポート担当者には、上長の承認なしで問題を解決できる権限（例: 一定額までの返金、クーポン発行）を付与する。**たらい回しゼロ**を義務化する。
    *   WOW体験: マニュアル外の「WOW」な体験提供を推奨する（例: 手書きメッセージ、記念日サプライズ）。
*   **First Contact Resolution (FCR) Target**: FCR率 **≥ 70%** を目標とする。FCRが低い場合は、ナレッジベース・エージェントトレーニング・権限委譲の不足を疑うこと。

### 1.3. The Support-Driven Development Protocol（サポート駆動開発）
*   **Law**: サポートへの問い合わせをプロダクト改善のシグナルとして体系的に活用すること。
*   **3-Strike Rule**: 同一内容の問い合わせが **3件** 発生した時点で、自動的にGitHub Issueを起票し、開発バックログの優先度を引き上げる。
*   **Bug Report Fast Track**: ユーザーからのバグ報告は最優先で検証し、修正完了後は必ず**報告者個人に**完了通知と感謝を伝えること。
*   **Product-Support Sync**: 週次でサポートチームとプロダクトチームの定期ミーティングを実施し、Top 5問い合わせカテゴリとトレンドデータを共有すること。

### 1.4. The Effortless Experience Principle（エフォートレス体験原則）
*   **Law**: ユーザーの「手間（Effort）」を最小化することが、ロイヤルティ向上の最大ドライバーである（Gartner CEB研究）。
*   **Zero Repeat Contact**: ユーザーが同じ問題で2回以上連絡する状況を構造的に排除すること。
*   **Channel Stickiness**: ユーザーが最初に選んだチャネルで解決を完結させること。チャネル切り替えを強制しない。
*   **Anticipatory Service**: ユーザーが問い合わせる前に、問題を検知し先回りで解決すること（Part XXIXプロアクティブサポート参照）。
*   **Effort Budget**: 1つの問題解決に必要なユーザーの操作を **5アクション以内** に制限する設計を目標とすること。

### 1.5. The Support Excellence Culture（サポートエクセレンス文化）
*   **Law**: サポート品質は組織文化に根ざす。全社的な「カスタマーファースト」文化を制度化すること。
*   **Executive Support Shadow**: 経営層が四半期に1回以上、サポートチケット対応を体験する「Support Shadow Day」を実施。
*   **All-Hands Support**: エンジニア・PM等の非サポート職が定期的にサポート対応に参加する制度（推奨: 月1回・2時間）。
*   **Customer Story Sharing**: 全社ミーティングでサポート事例（成功・失敗の両方）を共有する時間を設けること。

---

## Part II: AIエージェントサポート戦略

### 2.1. The AI Triage Protocol（AIトリアージ）
*   **Law**: 全問い合わせをLLMで即座に分類（技術的問題/課金/要望/バグ報告）し、緊急度（Severity: P0-P3）を自動判定すること。
*   **PII Scrubbing Mandate**: AIへの問い合わせ転送前に、`400_ai_engineering.md` のPII Scrubbingルールに準拠し、個人情報（氏名、電話番号、メールアドレス）を正規表現等でマスクすること。
*   **Confidence Threshold**: AIの分類信頼度が **80%未満** の場合は、自動的に人間のエージェントにルーティングすること。
*   **Intent Detection**: 単純なキーワードマッチではなく、セマンティック分析によるインテント検出を標準とすること。
*   **Multi-Intent Handling**: 1つのメッセージに複数の意図が含まれる場合（例:「課金エラーと機能要望」）、各意図を分離して並列処理すること。

### 2.2. The Agentic AI Support Standard（エージェント型AIサポート）
*   **Law**: 2025年以降のAIサポートは単純なFAQボットではなく、**タスク実行・問題解決を自律的に遂行できるAgentic AIアーキテクチャ**を標準とすること。
*   **Capability Tiers**:

    | Tier | 能力 | 例 | 解決率目標 |
    |:-----|:-----|:---|:----------|
    | **L1: 情報提供** | 質問に回答、ドキュメントへのリンク提示 | FAQ回答、ナレッジベース検索 | 95% |
    | **L2: ガイド付き操作** | ステップバイステップで操作を案内 | アカウント設定変更の手順案内 | 90% |
    | **L3: 代行実行** | ユーザーの許可を得て操作を代行 | プラン変更、返金処理の実行 | 85% |
    | **L4: プロアクティブ介入** | リスク検知時に自発的に連絡 | 異常検知時の事前通知 | 80% |
    | **L5: 自律解決** | 複雑なワークフローを自律的に遂行 | マルチステップの問題解決、API連携解決 | 70% |

*   **Human-in-the-Loop Mandate**: L3（代行実行）以上の操作は、必ず**ユーザーの明示的な同意**を取得してから実行すること。AIの独断による課金操作・データ変更は厳禁。
*   **Escalation Trigger**: AIが3回以上やり取りしても解決できない場合、自動的に人間エージェントにエスカレーションすること。
*   **Multi-Agent Orchestration**: 複雑な問い合わせに対し、専門特化した複数AIエージェント（課金Agent、技術Agent、アカウントAgent）が協調して問題解決にあたるアーキテクチャを推奨。

### 2.3. The AI Agent Tool Use & Integration Standard（AIエージェントTool Use基準）
*   **Law**: Agentic AIサポートにおいて、AIエージェントが安全に外部ツール・APIを呼び出すための設計基準を定義すること。
*   **Tool Use Design**:
    *   **Allow List**: AIが呼び出し可能なAPI/ツールをホワイトリストで明示的に定義
    *   **Scope Limitation**: 各ツールの実行スコープを最小権限に制限（例: 返金APIは上限$100まで）
    *   **Dry Run Mode**: 破壊的操作（削除・課金変更）は実行前にプレビューをユーザーに提示
    *   **Audit Trail**: 全Tool Use実行をタイムスタンプ付きで監査ログに記録
*   **MCP/A2A Integration**: Model Context Protocol（MCP）やAgent-to-Agent（A2A）プロトコルを活用し、AIエージェント間の安全な情報共有とタスク委譲を標準化すること。

### 2.4. The AI Copilot for Agent Protocol（エージェント向けAI Copilot）
*   **Law**: 人間のサポートエージェントにAI Copilotを提供し、対応品質と速度を向上させること。
*   **Required Capabilities**:
    *   **リアルタイム回答候補提示**: 過去のナレッジベース・チケット履歴からの回答ドラフト生成
    *   **センチメント分析**: ユーザーの感情状態のリアルタイム検出（怒り/不満/中立/満足）
    *   **コンテキスト要約**: 長いチケット履歴の自動要約
    *   **ネクストベストアクション提案**: 最適な対応策のレコメンデーション
    *   **類似チケット検索**: 過去の解決済みチケットからの類似事例自動検出
    *   **コンプライアンスチェック**: 返信内容のポリシー違反・トーン逸脱の自動検出
    *   **Real-time Translation**: エージェントとユーザーの言語が異なる場合のリアルタイム翻訳支援
*   **Override Principle**: AI Copilotの提案は「提案」であり、最終判断は常に人間エージェントが行うこと。
*   **Copilot Adoption KPI**: Copilot提案の採用率を追跡し、低採用率の提案カテゴリを特定・改善すること（目標: 採用率 ≥ 60%）。

### 2.5. The Conversational AI Design Standard（会話型AI設計基準）
*   **Law**: AIチャットボット・バーチャルアシスタントは以下の品質基準を満たすこと。
*   **Persona Consistency**: ブランドの声・トーンと一貫したペルソナを設定し、全インタラクションで維持すること。
*   **Graceful Handoff**: AIから人間エージェントへの引き継ぎ時、会話コンテキスト全体（要約含む）をシームレスに転送すること。ユーザーが同じ説明を繰り返す必要がある状態は禁止。
*   **Multilingual Support**: ターゲット市場の言語に対応し、言語の自動検出と切り替えをサポートすること。
*   **Anti-Hallucination**: ナレッジベースに存在しない情報を「創作」して回答することを禁止。不明な場合は「お調べします」と人間にエスカレーションすること。
*   **Grounding & Citation**: AIの回答は必ずナレッジベースの特定記事にGroundingし、参照元リンクを回答に含めること。
*   **Conversation Memory**: 同一ユーザーとの過去の会話履歴を参照し、コンテキストを維持すること。
*   **Prompt Injection Defense**: ユーザー入力からのプロンプトインジェクション攻撃を検出・防御するガードレールを実装すること（`600_security_privacy.md` 参照）。
*   **Cross-Reference**: `400_ai_engineering.md` — ガードレール設計、RAG設計、ハルシネーション防止

### 2.6. The AI Quality Assurance Standard（AI品質保証基準）
*   **Law**: AIサポートの品質を継続的にモニタリング・改善すること。
*   **AI QA Metrics**:

    | 指標 | 目標 | 計測頻度 |
    |:-----|:-----|:--------|
    | **Autonomous Resolution Rate** | ≥ 80% | リアルタイム |
    | **AI CSAT** | ≥ 4.0 / 5.0 | 日次 |
    | **Hallucination Rate** | ≤ 1% | 週次 |
    | **Grounding Accuracy** | ≥ 98% | 週次 |
    | **Escalation Rate** | ≤ 20% | 日次 |
    | **Average Handle Time (AI)** | ≤ 2分 | リアルタイム |
    | **Intent Recognition Accuracy** | ≥ 95% | 週次 |
    | **Tool Use Success Rate** | ≥ 95% | 日次 |

*   **Feedback Loop**: AIが誤回答した場合、人間エージェントがフラグを立て、ナレッジベース更新→AIモデル改善のループを回すこと。
*   **AI Agent Observability**: AIエージェントの推論プロセス、Tool Use呼び出し、レイテンシをOpenTelemetryで計装し、異常検知アラートを構築すること。

---

## Part III: オムニチャネルサポート設計

### 3.1. The Omnichannel Integration Mandate（オムニチャネル統合義務）
*   **Law**: メール、チャット、SNS、電話、アプリ内サポートを**一元管理プラットフォーム**（Zendesk、Intercom、Freshdesk等）で統合し、チャネル間のコンテキストを完全に共有すること。
*   **Zero Context Loss**: ユーザーがチャネルを切り替えた場合（例: チャット→メール）、過去の会話履歴・コンテキストが完全に引き継がれること。ユーザーに同じ説明を再度させることは禁止。
*   **Unified Customer View**: 全チャネルのインタラクション履歴を統合した「統一顧客ビュー」をエージェントに提供すること。
*   **Channel Performance Parity**: 全チャネルで同等の品質水準（CSAT ± 0.3以内の差異）を維持すること。チャネル間の品質格差を月次で監視。

### 3.2. The Channel Strategy Matrix（チャネル戦略マトリクス）
*   **Law**: 問い合わせの性質に応じて最適なチャネルを定義し、ユーザーを誘導すること。

    | 問い合わせ種別 | 推奨チャネル | 理由 |
    |:-------------|:-----------|:-----|
    | **緊急の技術障害** | ライブチャット / 電話 / ビデオ | 即時対応が必要 |
    | **一般的な質問** | AIチャットボット / FAQ | セルフサービスで即時解決 |
    | **複雑な技術問題** | メール / チケット / スクリーンシェア | 詳細な調査が必要 |
    | **機能要望・フィードバック** | アプリ内フィードバック | プロダクトチームへの直結 |
    | **アカウント・課金** | ライブチャット / メール | 認証確認が必要 |
    | **SNS上の言及・苦情** | SNSダイレクト返信 | パブリックな迅速対応 |
    | **B2B Enterprise** | 専任CSM / Slack Connect | リレーションシップ重視 |

### 3.3. The Real-Time Channel Standard（リアルタイムチャネル基準）
*   **Live Chat SLA**: ライブチャットの初回応答は **30秒以内** を目標とすること。
*   **Typing Indicator**: エージェントが入力中であることをリアルタイムで表示すること（ユーザーの離脱防止）。
*   **Proactive Chat**: 特定のページ（料金ページ、解約ページ等）で一定時間（推奨: 60秒）滞留したユーザーに、プロアクティブにチャットを提示すること。
*   **Chat Transcript**: チャット終了後、完全なトランスクリプトをメールで送信するオプションを提供すること。
*   **Video Support**: 複雑な技術問題に対し、ビデオ通話・スクリーンシェアによるリアルタイムサポートオプションを提供すること。
*   **Messaging Platforms**: WhatsApp Business API、LINE公式アカウント等のメッセージングプラットフォーム統合をサポートすること。
*   **Async-First Design**: 非同期チャット（ユーザーが離脱後も会話が継続）をデフォルトとし、ユーザーの時間的制約を尊重すること。

---

## Part IV: チケット管理・SLA

### 4.1. The Tiered SLA Standard（段階的SLA基準）
*   **Law**: 問い合わせの緊急度・重要度に応じた段階的SLAを定義し、厳格に遵守すること。

    | 優先度 | 定義 | 初回応答 | 解決目標 |
    |:------|:-----|:---------|:---------|
    | **P0 (Critical)** | サービス全体の停止、データ漏洩 | **15分以内** | **4時間以内** |
    | **P1 (High)** | 主要機能の障害、課金エラー | **1時間以内** | **8時間以内** |
    | **P2 (Medium)** | 部分的な機能不具合 | **4時間以内** | **24時間以内** |
    | **P3 (Low)** | 一般的な質問、機能要望 | **24時間以内** | **72時間以内** |

*   **Business Hours Definition**: SLAの営業時間定義を明文化すること（例: 平日9:00-18:00 JST。P0は24/7対応）。
*   **SLA Breach Alert**: SLA違反が迫った場合（残り20%の時点）、自動的にマネージャーに通知すること。
*   **SLA by Segment**: Enterpriseセグメントには専用SLA（プレミアムSLA）を提供し、通常SLAより厳格な基準を適用すること。
*   **SLA Clock Pause**: ユーザー待ち状態（Pending）ではSLAタイマーを一時停止し、正確な対応時間を計測すること。

### 4.2. The Ticket Lifecycle Standard（チケットライフサイクル基準）
*   **Law**: チケットの状態遷移を標準化し、全チケットを追跡可能にすること。
*   **Standard States**: `New → Open → Pending (ユーザー待ち) → In Progress → Resolved → Closed`
*   **Auto-Close Rule**: 「Resolved」状態から **7日間** ユーザーからの返信がない場合、自動的に「Closed」に遷移すること。クローズ前に確認通知を送信すること。
*   **Reopen Policy**: クローズ後 **30日以内** のチケットは再オープンを許可し、同一コンテキストで対応を継続すること。
*   **Merge Protocol**: 同一ユーザーからの重複チケットは自動検出し、マージを提案すること。
*   **Stale Ticket Alert**: 5日以上更新のないアクティブチケットに自動アラートを発火し、放置を防止すること。

### 4.3. The Ticket Tagging & Classification Standard（タグ・分類基準）
*   **Law**: 全チケットに以下の分類タグを付与し、分析可能なデータとして蓄積すること。
*   **Required Tags**:
    *   **カテゴリ**: `bug` / `feature_request` / `billing` / `account` / `how_to` / `integration`
    *   **プロダクト領域**: 機能・モジュール単位の分類
    *   **根本原因**: `product_bug` / `documentation_gap` / `user_error` / `third_party`
    *   **解決方法**: `self_resolved` / `agent_resolved` / `ai_resolved` / `engineering_fix` / `escalated`
    *   **センチメント**: `positive` / `neutral` / `negative` / `escalated`
*   **AI Auto-Tagging**: AIによる自動タグ付与を実装し、手動タグ付けの負荷を 80%以上削減すること。タグ付与精度は週次で監査（目標: 精度 ≥ 90%）。

---

## Part V: エスカレーション設計

### 5.1. The Escalation Matrix Protocol（エスカレーションマトリクス）
*   **Law**: エスカレーションの基準・経路・責任を明確に定義し、全エージェントが遅延なくエスカレーションできる体制を構築すること。
*   **Escalation Types**:

    | 種別 | トリガー | エスカレーション先 |
    |:-----|:--------|:----------------|
    | **階層的** | SLA超過、ユーザーの明示的要求 | チームリーダー → マネージャー → ディレクター |
    | **機能的** | 専門知識が必要 | 技術サポート → エンジニアリング → SRE |
    | **優先度** | P0/P1インシデント | インシデントコマンダー（`503_incident_response.md` 参照） |
    | **感情的** | ユーザーの強い不満・怒り | デエスカレーション専門担当 |
    | **セキュリティ** | セキュリティインシデントの疑い | セキュリティチーム即時（`600_security_privacy.md` 参照） |

### 5.2. The Escalation Handoff Standard（引き継ぎ基準）
*   **Law**: エスカレーション時は以下の情報を必ず引き継ぎ文に含めること。
*   **Required Information**:
    1.  **問題の要約**: 1-2文での簡潔な問題説明
    2.  **再現手順**: 技術的問題の場合の再現ステップ
    3.  **実施済み対応**: これまでに試みた解決策のリスト
    4.  **ユーザーの温度感**: センチメント（怒り/不満/中立の判定）
    5.  **ビジネスインパクト**: 影響を受けるユーザー数・収益影響
    6.  **タイムライン**: SLA残り時間とこれまでの経過時間
*   **Anti-Pattern**: 引き継ぎ情報なしのエスカレーション（「見てください」のみ）は禁止。
*   **AI-Assisted Handoff**: AIが自動的にエスカレーションサマリーを生成し、引き継ぎ品質のばらつきを排除すること。

### 5.3. The Engineering Escalation Protocol（エンジニアリングエスカレーション基準）
*   **Law**: サポートからエンジニアリングへのエスカレーション基準を明確化すること。
*   **Trigger Criteria**:
    *   バグの再現が確認され、サポート側では修正不可能
    *   インフラ障害の兆候がある
    *   セキュリティインシデントの疑い（即時エスカレーション義務）
*   **Engineering SLA**: エンジニアリングへのエスカレーション後、**4時間以内**に初回トリアージ（受領確認 + 優先度判定）を完了すること。
*   **Feedback Loop**: エンジニアリングが解決した問題の根本原因を、サポートチームにフィードバックし、ナレッジベースに反映すること。
*   **Cross-Reference**: `502_site_reliability.md` — インシデント管理プロトコル

---

## Part VI: セルフサービス・ナレッジベース

### 6.1. The Self-Service First Principle（セルフサービスファースト原則）
*   **Law**: ユーザーが人間のサポートに連絡する**前に**、セルフサービスで問題を解決できる環境を最優先で構築すること。
*   **Deflection Rate Target**: セルフサービスによるチケット回避率（Deflection Rate）**≥ 40%** を目標とすること。
*   **Self-Service Channels**:
    *   AIチャットボット
    *   ナレッジベース / FAQ
    *   コミュニティフォーラム
    *   インタラクティブチュートリアル / ウォークスルー
    *   ステータスページ
    *   トラブルシューティングウィザード
    *   インタラクティブ診断ツール（Decision Tree型）

### 6.2. The Knowledge Base Architecture Standard（ナレッジベース設計基準）
*   **Law**: ナレッジベースは以下の設計原則に従って構築すること。
*   **Structure**:
    *   **カテゴリベース**: 機能領域ごとの論理的分類
    *   **検索最適化**: 全文検索 + AI セマンティック検索の両方をサポート
    *   **多言語対応**: ターゲット市場の全言語で記事を提供
*   **Article Quality Standard**:
    *   専門用語を避け、平易な言葉で記述
    *   スクリーンショット・GIF動画を**必ず**添付（テキストのみの記事は禁止）
    *   **ステップバイステップ形式**で記述（番号付きリスト）
    *   各記事に「この記事は役に立ちましたか？」フィードバックウィジェットを設置
    *   **Reading Level**: 記事の読解レベルを中学生レベル以下に維持（Flesch-Kincaid相当）

### 6.3. The Dynamic Knowledge Update Protocol（動的ナレッジ更新）
*   **Law**: ナレッジベースを「生きたドキュメント」として継続的に更新すること。
*   **3-Strike Auto-Create Rule**: 同一質問が3回来たら、**48時間以内**にナレッジベース記事を作成するか、プロダクトUIを改善して質問を発生させないようにすること。
*   **Freshness Check**: 全記事を**90日ごと**にレビューし、古い情報を更新・アーカイブすること。
*   **Usage Analytics**: 各記事の閲覧数・フィードバックスコア・検索ヒット率を追跡し、低評価記事の改善を優先すること。
*   **Version History**: 記事の変更履歴を保持し、ロールバック可能にすること。
*   **Content Gap Analysis**: AIが検索クエリを分析し、ヒットしなかった検索語（Zero Results）からコンテンツギャップを自動特定すること。

### 6.4. The In-App Contextual Help Standard（アプリ内コンテキストヘルプ）
*   **Law**: ナレッジベースへのリンクだけでなく、**アプリ内の文脈に応じたヘルプ**を提供すること。
*   **Tooltip / Guided Tour**: 複雑な機能にはツールチップやガイドツアーを実装すること。
*   **Contextual Search**: ユーザーが現在閲覧中の画面に関連するヘルプ記事を自動的にサジェストすること。
*   **Interactive Troubleshooter**: 問題症状を段階的に絞り込むDecision Tree型の対話型トラブルシューターを実装すること。
*   **Smart Suggestions**: ユーザーのエラー発生時に、関連するヘルプ記事をエラーメッセージ内で直接リンクすること。
*   **Cross-Reference**: `200_design_ux.md` — おもてなしUX、エラーメッセージUX基準

---

## Part VII: カスタマーサクセス戦略

### 7.1. The Customer Success Operating Model（CS運用モデル）
*   **Law**: カスタマーサクセスを「リアクティブなサポート」ではなく、「プロアクティブな価値実現支援」として運用すること。
*   **CS vs. Support 責務分離**:

    | 機能 | サポート (Reactive) | カスタマーサクセス (Proactive) |
    |:-----|:-------------------|:---------------------------|
    | **トリガー** | ユーザーからの問い合わせ | データシグナル・ライフサイクルイベント |
    | **目標** | 問題解決・チケットクローズ | 価値実現・リテンション・Expansion |
    | **KPI** | 応答時間、解決時間、CSAT | NRR、健全性スコア、Time-to-Value |

### 7.2. The Customer Segmentation Standard（顧客セグメンテーション基準）
*   **Law**: 全顧客をARR（Annual Recurring Revenue）またはプラン種別に基づいてセグメント化し、タッチモデルを定義すること。

    | セグメント | 基準（例） | タッチモデル | CSM割り当て |
    |:---------|:---------|:-----------|:-----------|
    | **Enterprise** | ARR ≥ $100K | ハイタッチ（専任CSM） | 1:10-20 |
    | **Mid-Market** | ARR $10K-$100K | ミッドタッチ（共有CSM + 自動化） | 1:50-100 |
    | **SMB / Self-Serve** | ARR < $10K | テックタッチ（完全自動化） | なし（Digital CS） |

*   **Tech-Touch Automation**: テックタッチセグメントには、自動化されたオンボーディングメール、In-Appガイド、ヘルスアラートを実装すること。
*   **Dynamic Segmentation**: 顧客のライフサイクルステージ・利用状況の変化に応じて、セグメントの動的再分類を実施すること。

### 7.3. The Expansion & Upsell Protocol（拡張・アップセル）
*   **Law**: CSチームが適切なタイミングでExpansion機会を特定し、Revenue貢献すること。
*   **Trigger Events**:
    *   利用量がプラン上限の **80%** に到達
    *   高度な機能への繰り返しアクセス（有料プランの機能をトライアル利用）
    *   Health Scoreが高い（Promoter）ユーザーからの好意的なフィードバック
    *   **Product Qualified Signals (PQS)**: 特定の機能利用パターンがExpansionの強いシグナル
*   **Anti-Pattern**: Health Scoreが低い（Detractor）ユーザーへの売り込みは禁止。まず課題解決を優先すること。
*   **Consumption-Based Alerts**: Usage-Based Pricing（UBP）モデルの場合、利用量トレンドに基づく予測的なアップグレード推奨を自動化すること。

---

## Part VIII: Customer Health Score

### 8.1. The Health Score Framework（ヘルススコアフレームワーク）
*   **Law**: 全顧客に対して動的なHealth Score（健全性スコア）を算出し、リスク管理とプロアクティブ介入に活用すること。
*   **Score Components（推奨ウェイト）**:

    | カテゴリ | 指標例 | ウェイト |
    |:--------|:------|:--------|
    | **プロダクト利用** | DAU/MAU比率、主要機能利用率、セッション時間、Feature Adoption | 30% |
    | **エンゲージメント** | ログイン頻度、NPS/CSATスコア、コミュニティ参加、トレーニング受講率 | 25% |
    | **サポート** | チケット数、未解決チケット、エスカレーション頻度、CESスコア | 20% |
    | **契約・財務** | 支払い遅延、契約更新時期、利用量トレンド、請求書エラー率 | 15% |
    | **関係性** | CSMとの定期MTG実施率、Execスポンサー有無、チャンピオン人数 | 10% |

*   **Score Range**: 0-100のスコアで表現し、以下の閾値でアクションをトリガーすること。

    | スコア | ステータス | アクション |
    |:------|:---------|:---------|
    | **80-100** | 🟢 Healthy | Expansion機会の探索、アドボカシー依頼 |
    | **60-79** | 🟡 Neutral | 定期チェックイン、エンゲージメント強化 |
    | **40-59** | 🟠 At Risk | リスク軽減プラン策定、即時介入 |
    | **0-39** | 🔴 Critical | 即時介入（CSM + マネージャー + Exec Sponsor） |

### 8.2. The Predictive Health Analytics Standard（予測分析基準）
*   **Law**: Health Scoreは静的なスナップショットではなく、MLモデルによる**予測的分析**を組み込むこと。
*   **Trend Detection**: スコアの推移トレンド（上昇/下降/横ばい）を可視化し、**下降トレンドが2週間以上継続**した場合にアラートを発火すること。
*   **Churn Prediction**: 過去の解約データを学習し、解約確率を予測するモデルを構築すること。
*   **Feature Engineering（推奨特徴量）**:
    *   過去30日のログイン日数 / 前月比
    *   主要機能利用率の週次変化率
    *   サポートチケットのセンチメントスコア移動平均
    *   契約更新までの残日数
    *   決済失敗回数（過去90日）
    *   チャンピオンユーザーのアクティビティ変化率
*   **Cohort Analysis**: セグメント別・業種別・利用開始時期別のコホート分析を実施し、パターンを特定すること。
*   **Propensity Scoring**: Expansion/Upsellの可能性を予測するPropensity Scoreを算出し、CSQLの優先順位付けに活用すること。
*   **Cross-Reference**: `401_data_analytics.md` — 分析ダッシュボード品質基準

---

## Part IX: オンボーディング設計

### 9.1. The Onboarding Success Framework（オンボーディング成功フレームワーク）
*   **Law**: ユーザーの**Time-to-Value（価値実現時間）を最短化**するオンボーディング体験を設計すること。
*   **First Value Milestone**: ユーザーが最初の価値を体験する「Aha! Moment」を定義し、**7日以内**にそのマイルストーンへ到達させることを目標とすること。
*   **Progressive Disclosure**: 全機能を一度に提示せず、段階的に紹介する設計を採用すること。
*   **Time-to-Value Benchmark**: セグメント別のTTV（Time-to-Value）を計測し、継続的に短縮すること。
*   **Onboarding Completion Correlation**: オンボーディング完了率と12ヶ月後のリテンション率の相関を分析し、オンボーディングの改善がリテンションに与える影響を定量化すること。

### 9.2. The Onboarding Checklist Standard（オンボーディングチェックリスト基準）
*   **Law**: 新規ユーザーに対してインタラクティブなオンボーディングチェックリストを提供すること。
*   **Requirements**:
    *   完了率のプログレスバー表示（達成感の演出）
    *   各ステップに推定所要時間を表示
    *   スキップ可能な設計（強制は禁止）
    *   完了時のお祝い演出（コンフェッティ等のマイクロインタラクション）
*   **Completion Tracking**: チェックリスト完了率をセグメント別に追跡し、離脱が多いステップを特定・改善すること。

### 9.3. The Segmented Onboarding Standard（セグメント別オンボーディング）
*   **Law**: ユーザーのペルソナ・利用目的に応じてオンボーディングフローを分岐させること。
*   **Role-Based**: 管理者/一般ユーザー/ゲストで異なるオンボーディングパスを提供
*   **Use-Case Based**: サインアップ時に利用目的を質問し、パーソナライズされた初期設定を提供
*   **Cross-Reference**: `102_growth_marketing.md` — PLG（プロダクト主導型成長）、オンボーディング

### 9.4. The Customer Education & Academy Standard（カスタマー教育基準）
*   **Law**: オンボーディング後の継続的な学習を支援するCustomer Education体制を構築すること。
*   **Education Programs**:

    | プログラム | 対象 | 形式 | 目的 |
    |:---------|:-----|:-----|:-----|
    | **入門コース** | 新規ユーザー | セルフペース動画 | 基本操作の習得 |
    | **応用コース** | アクティブユーザー | ウェビナー / ワークショップ | 高度機能の活用 |
    | **認定プログラム** | パワーユーザー / パートナー | 試験 + バッジ | 専門性の証明 |
    | **ベストプラクティス** | 全ユーザー | ブログ / ケーススタディ | 成功パターンの共有 |

*   **LMS Integration**: Learning Management System（LMS）を活用し、学習進捗・完了率を追跡すること。
*   **Training-Revenue Correlation**: Education受講率とExpansion率の相関を分析し、ROIを可視化すること。

---

## Part X: 解約防止・リテンション

### 10.1. The Churn Signal Detection Protocol（チャーン予兆シグナル）
*   **Law**: 以下のリスクシグナルを定義し、自動検知と段階的介入を実装すること。

    | シグナル | 閾値 | リスクレベル |
    |:--------|:-----|:-----------:|
    | **ログイン頻度の低下** | 過去14日間ログインなし | Medium |
    | **主要機能の未利用** | 過去7日間の主要機能利用が0 | Medium |
    | **サポート問い合わせの増加** | 月3件以上のチケット | High |
    | **決済失敗** | 2回連続の支払い失敗 | Critical |
    | **解約ページ訪問** | 解約ページへのアクセス | Critical |
    | **NPS Detractor回答** | NPS 0-6を回答 | High |
    | **利用量の急減** | 前月比50%以上の利用量減少 | High |
    | **チャンピオンユーザーの離脱** | 主要利用者のアカウント停止 | Critical |
    | **競合ツールの検索** | ヘルプ内での競合名検索 | Medium |

*   **Automated Action**:
    *   **Medium**: パーソナライズされたリエンゲージメントメール送信
    *   **High**: CS担当者に通知 + 限定オファー自動提示
    *   **Critical**: 即時リテンション施策発動（リテンションオファー等）

### 10.2. The Staged Re-engagement Protocol（段階的リエンゲージメント）
*   **Law**: 30日以上非アクティブなユーザーに対し、段階的にリエンゲージメントを試みること。
*   **Steps**:
    1.  **Day 30**: 「お久しぶりです」メール + 新機能・新コンテンツのハイライト
    2.  **Day 60**: 限定クーポン（期間限定特典）付きメール
    3.  **Day 90**: 最終案内メール + アカウント休眠の事前通知
    4.  **Day 120**: アカウント休眠処理
*   **Tone**: 温かみのあるトーンとし、プレッシャーを与える表現（「今すぐ戻らないと...」等）を禁止する。
*   **Measurement**: 各ステップの復帰率（Resurrection Rate）を計測し、施策効果を継続的に改善すること。
*   **A/B Testing**: リエンゲージメントメールの件名・内容・送信タイミングをA/Bテストで最適化すること。

### 10.3. The Cancellation Flow Standard（解約フロー設計基準）
*   **Law**: 解約手続きは **3ステップ以内** で完了できる設計を義務付ける。
*   **Steps**:
    1.  **理由収集**: 解約理由の選択（ドロップダウン + 自由記述・任意）
    2.  **リテンションオファー**: 引き留めオファー（任意・**1回限り**）。例: 「翌月無料」「プランダウングレード」
    3.  **最終確認**: 確認画面 + 即時解約実行
*   **Confirmation**: 解約完了後、即座に確認メールを送信し、「いつでも再開できます」の導線を含めること。
*   **Anti-Dark Pattern（厳禁事項）**:
    *   解約ボタンを意図的に隠す・見つけにくくする
    *   複数回の引き留めモーダルを連続表示する
    *   電話や窓口でしか解約できない設計にする
    *   解約完了までに不必要なステップを追加する
*   **Win-Back Campaign**: 解約後30日・60日・90日にWin-Backメールを送信。特別オファー付き。
*   **Involuntary Churn Prevention**: 決済失敗による非自発的解約を防ぐため、Dunning Management（督促管理）を実装すること（リトライスケジュール、カード更新案内、代替決済手段提示）。
*   **Cancellation Reason Analytics**: 解約理由データを月次で集計・分析し、プロダクト改善にフィードバックすること。Top 3解約理由に対するアクションプランを必ず策定。
*   **Cross-Reference**: `601_data_governance.md` — ダークパターン禁止、GDPR削除権

---

## Part XI: VoC・フィードバックループ

### 11.1. The VoC Pipeline Protocol（VoCパイプライン）
*   **Law**: ユーザーの声（Voice of Customer）を体系的に収集・分析・反映するプロセスを確立すること。
*   **Collection Channels**:

    | チャネル | 収集方法 | 頻度 |
    |:--------|:---------|:-----|
    | **アプリ内フィードバック** | フィードバックウィジェット | 常時 |
    | **NPS/CSAT/CES** | 定期アンケート | 計測基準に準拠 |
    | **アプリストアレビュー** | App Store / Google Play評価の分析 | 週次 |
    | **サポートチケット** | 問い合わせ内容の分類・集計 | 週次 |
    | **SNS監視** | ブランド言及の検出 | 日次 |
    | **セールス/CSフィードバック** | 商談・面談からの声 | 都度 |
    | **コミュニティフォーラム** | ディスカッション・投票 | 日次 |
    | **録音・チャットログ分析** | Conversation Intelligenceによる自動抽出 | 週次 |

*   **Analysis**: 収集したフィードバックをカテゴリ分類（機能要望、バグ報告、UX改善、コンテンツ）し、**月次でプロダクトロードマップに反映**すること。
*   **Close the Loop（ループを閉じる義務）**: フィードバックに基づく改善実施後、報告してくれたユーザーに改善完了を通知すること。未対応フィードバックも定期的にステータスを更新し、ユーザーの声が「ブラックホール」に消えないようにすること。
*   **AI-Powered Theme Detection**: AIがフィードバックの自動テーマ抽出を行い、新興のトレンド・問題を早期に特定すること。

### 11.2. The Feedback Widget UX Standard（フィードバックウィジェットUX基準）
*   **Law**: アプリ内フィードバックウィジェットは以下の品質基準を満たすこと。
*   **Accessibility**: 全画面から2クリック以内でアクセス可能にすること。
*   **Low Friction**: 最小入力（感情選択 + 自由記述・任意）で送信可能にすること。
*   **Screenshot Attach**: スクリーンショットの添付機能を提供すること。
*   **Context Auto-Attach**: 送信時にURL・デバイス情報・ブラウザ情報を自動的に付与すること（PII は除外）。
*   **Session Replay Link**: フィードバック送信時にセッションリプレイのリンクを自動添付し、問題の再現性を向上させること（ユーザー同意が前提）。

---

## Part XII: NPS/CSAT/CES計測基準

### 12.1. The NPS Measurement Standard（NPS計測基準）
*   **Law**: 顧客ロイヤルティの定量指標としてNet Promoter Score（NPS）を採用し、継続的に計測すること。
*   **Survey Timing**: サービス利用開始後30日、60日、以降90日ごとにアプリ内でNPSアンケートを表示すること。
*   **Question**: 「友人や知人にこのサービスをどの程度勧めたいですか？（0-10）」
*   **Follow-up**:
    *   **Promoter (9-10)**: 「最も気に入っている点を教えてください」
    *   **Passive (7-8)**: 「改善してほしい点はありますか？」
    *   **Detractor (0-6)**: 「ご不満な点をお聞かせください」
*   **Target**: NPS **≥ 40** を目標値とする。
*   **Response Rate Target**: **≥ 20%**。

### 12.2. The CSAT Measurement Standard（CSAT計測基準）
*   **Law**: 特定のインタラクション完了後にCSATを計測すること。
*   **Trigger Design**:

    | トリガー例 | 表示タイミング | 質問例 |
    |:---------|:-------------|:------|
    | **AI機能利用完了** | 機能利用終了時 | 「回答は参考になりましたか？」👍/👎 |
    | **検索完了** | 検索結果表示後 | 「お探しの情報は見つかりましたか？」 |
    | **サポート対応完了** | チケットクローズ後 | 「サポート対応にご満足いただけましたか？（1-5）」 |

*   **Target**: 全CSATスコアの平均 **≥ 4.2 / 5.0** を目標とすること。

### 12.3. The CES Measurement Standard（CES計測基準）
*   **Law**: Customer Effort Score（CES）は、ユーザーが目的達成にどの程度「手間」を感じたかを計測する指標。
*   **Trigger**: サポート問い合わせ解決後、セルフサービス機能利用後。
*   **Question**: 「問題の解決は簡単でしたか？」（7段階スケール）
*   **Target**: CESスコア平均 **≥ 5.5 / 7.0**。
*   **Action**: 「難しい」と回答したユーザーのフリクション原因を分析し、UX改善またはFAQ拡充に反映すること。

### 12.4. The Survey Widget UX Standard（アンケートウィジェットUX基準）
*   **Throttling**: 同一ユーザーへのアンケート表示は **7日間に最大1回** とすること（Survey Fatigue防止）。
*   **Skip Button**: 「回答しない」ボタンを必ず表示し、回答を強制しないこと。
*   **Auto-Close**: 表示後10秒以内に回答がない場合、自動的に閉じること。
*   **Non-Blocking**: メインコンテンツの操作を妨げない位置・レイヤーに配置すること。

### 12.5. The Survey Data Schema Standard（アンケートデータスキーマ基準）
*   **Recommended Schema**:

    | カラム | 型 | 説明 |
    |:-------|:---|:-----|
    | `id` | UUID | 一意識別子 |
    | `user_id` | UUID | 回答者（ユーザーテーブルへのFK） |
    | `survey_type` | TEXT | `nps` / `csat` / `ces` |
    | `trigger_event` | TEXT | トリガーイベント識別子 |
    | `score` | INT | スコア |
    | `feedback_text` | TEXT | 自由記述（任意・NULL許可） |
    | `segment` | TEXT | 回答時のユーザーセグメント |
    | `plan_tier` | TEXT | 回答時のプランティア |
    | `created_at` | TIMESTAMPTZ | 回答日時 |

### 12.6. The Analytics Dashboard Standard（分析ダッシュボード基準）
*   **Required Visualizations**:
    *   NPS推移チャート（月次・過去12ヶ月）
    *   CSAT分布（トリガー別ヒストグラム）
    *   Detractorアラート（NPS 0-6 即時通知）
    *   テキスト分析（ワードクラウド / カテゴリ別集計）
    *   セグメント別比較（プランティア別スコア比較）
    *   CESトレンド（チャネル別・機能別）
    *   AI vs Human CSAT比較チャート

---

## Part XIII: インタラクション設計（フォーム）

### 13.1. The Dynamic Form Runner（動的フォーム実行エンジン）
*   **Law**: 問い合わせフォーム等の入力フォームは、コードによるハードコードではなく、**DB/CMSに定義されたスキーマから動的に生成**される設計を標準とすること。
*   **Action**:
    1.  **Schema-Driven**: フォームのフィールド定義（名前、型、バリデーション、順序）をDB JSONB カラムまたは専用テーブルで管理
    2.  **No Deploy for Forms**: フォーム項目の追加・変更・削除にコードデプロイを不要とする設計を維持
    3.  **Validation Sync**: DB側のスキーマ定義に基づき、フロントエンドのバリデーションルールを自動生成
    4.  **Anti-Bot / Spam Protection**: 全フォームに**CAPTCHA またはチャレンジ認証**（Cloudflare Turnstile, reCAPTCHA等）を実装
    5.  **PII Access Restriction**: フォームから送信されたPIIは**管理者権限ユーザーのみ**閲覧可能とすること
    6.  **Smart Pre-fill**: ログイン済みユーザーの既知情報（名前、メール、プラン）を自動入力し、入力負荷を削減すること

---

## Part XIV: 通知・チャネル設計

### 14.1. The Channel Priority Protocol（チャネル優先度設計）
*   **Law**: ユーザーへの連絡手段に優先順位を定義し、最も到達率の高いチャネルから配信すること。
*   **Priority Cascade**: `アプリ内通知 > Email > SMS`。上位チャネル利用不可の場合はフォールバック。
*   **User Preference**: ユーザーが通知チャネルの有効/無効を設定できるUIを提供すること。

### 14.2. The Notification Channel Selection Matrix（通知チャネル選択基準）

| 緊急度 / 重要度 | 低重要度 | 高重要度 |
|:----------------|:---------|:---------|
| **即時（緊急）** | アプリ内通知（Toast） | メール + Push通知 |
| **通常** | アプリ内通知（Bell） | メール |
| **バッチ（定期）** | — | メールダイジェスト（週次等） |

*   **Unsubscribe**: マーケティング系通知にはワンクリック配信停止手段を必ず提供すること。

### 14.3. The In-App Notification Classification Standard（アプリ内通知分類基準）

| 種類 | 用途 | 表示方式 |
|:-----|:-----|:---------|
| **Toast（一時表示）** | 成功・完了メッセージ | 数秒後に自動消去 |
| **Bell（永続）** | 未読通知 | ベルアイコンのバッジ。既読管理をDBで実施 |
| **Banner（全体）** | メンテナンス通知等 | 画面上部に固定表示。管理画面から制御可能 |

*   **Locale Compliance**: 全通知文はターゲットロケールの自然な文面とすること。

### 14.4. The Notification Frequency Control Protocol（通知頻度制御）
*   **Daily Cap**: マーケティング通知は**3件/日**上限。
*   **Quiet Hours**: 夜間（21:00-8:00）のマーケティング通知は翌朝に遅延送信。トランザクション通知は対象外。
*   **One-Click Unsubscribe**: マーケティング通知には「配信停止」リンクを含め、ワンクリック解除を実現。各国法令（特定電子メール法、CAN-SPAM Act等）に準拠。
*   **Preference Center**: 通知カテゴリ（トランザクション/コミュニケーション/マーケティング/リマインダー）ごとのON/OFF制御UIを提供。

### 14.5. The Notification Category Matrix（通知カテゴリ分類基準）

| カテゴリ | 例 | チャネル | 即時性 |
|:--------|:---|:--------|:------|
| **トランザクション** | 予約確認、決済完了 | メール + Push | 即送 |
| **コミュニケーション** | UGCへの返信、問い合わせ回答 | メール + Push | 即送 |
| **マーケティング** | 新着情報、おすすめコンテンツ | Push | バッチ（日次） |
| **システム** | パスワード変更、セキュリティ通知 | メール | 即送 |
| **リマインダー** | 予約前日通知、アクション促進 | Push | スケジュール |

*   **Mandate**: 各カテゴリの通知文言・送信タイミングはプロジェクト固有のBlueprint側で定義すること。

---

## Part XV: メールテンプレート・品質基準

### 15.1. The Auto-Reply Mandate（自動応答義務）
*   **Law**: ユーザーからの問い合わせ送信時に、**自動応答（Auto-Reply）** で受付確認を即座に返すことを義務付ける。
*   **Instant Acknowledgment**: 問い合わせ送信直後に受付完了メールを送信。
*   **SLA Display**: 自動応答に対応予定時間（SLA）を明記すること。
*   **No Silent Submission（Ghost Feature禁止）**: フォーム送信後にフィードバックがない状態は厳禁。

### 15.2. The Email Template Structure Protocol（メールテンプレート構造基準）
*   **Mandate**: 全システムメールは以下の5要素を必須とする。

    | 要素 | 内容 | 品質基準 |
    |:-----|:-----|:--------|
    | **件名** | 簡潔かつ具体的（30文字以内推奨） | サービス名プレフィックス推奨 |
    | **挨拶** | ユーザー名を含む丁寧な挨拶 | ターゲットロケールの敬称形式 |
    | **本文** | 目的・結果・次のアクションを明示 | ターゲットロケールの丁寧表現で統一 |
    | **CTA** | 次の行動へのリンク | ボタン形式推奨、URL直書き併記 |
    | **署名** | サービス名、問い合わせ先、配信停止リンク | 該当国の法令準拠 |

*   **Plain Text**: HTMLメールには必ずプレーンテキスト版を同梱。
*   **Subject Anti-Pattern**:
    *   ❌ 内容不明な汎用件名（「お知らせ」）
    *   ❌ 過度に感情的な件名（「【緊急】すぐにご確認ください！！」）
    *   ❌ ターゲットロケールと異なる言語の件名

### 15.3. The Email Body Protocol（メール本文品質基準）
*   **Structure（3段構成）**:
    1.  **What**: 何が起きたか / 何をお知らせするか
    2.  **Why**: なぜこのメールが届いたか（心当たりがない場合の案内含む）
    3.  **Next**: 次に何をすべきか（CTAボタン + テキストリンク）
*   **Anti-Pattern**:
    *   技術用語の露出（"OTP Token", "Session ID", "UUID"等）禁止
    *   命令口調禁止
*   **Best Practice**:
    *   セキュリティ関連メールには「心当たりのない場合は無視してください」を含める
    *   リンクに有効期限を明記（例: 「24時間有効」）
*   **Send Retry**: 送信失敗時は最大3回リトライ。失敗はログ記録 + 管理者通知。
*   **Email Deliverability**: メール到達率を月次で計測し、**≥ 98%** を維持すること。バウンス率・スパム判定率を監視。

---

## Part XVI: メール送信ガバナンス

### 16.1. The Sender Identity Governance Protocol（送信元アイデンティティ管理基準）
*   **Law**: システムから送信される全メールの「差出人（From）」を用途別に整理し、信頼される表示名で統一すること。
*   **Purpose-Based Separation（最低3用途）**:

    | 用途 | アドレス例 | 表示名 |
    |:-----|:----------|:-------|
    | **トランザクション通知** | `noreply@{domain}` | {サービス名} |
    | **マーケティング** | `news@{domain}` | {サービス名} |
    | **お問い合わせ返信** | `support@{domain}` | {サービス名} サポート |

*   **Free Email Prohibition**: フリーメール（`@gmail.com`, `@yahoo.com`等）からのシステムメール送信禁止。
*   **Reply-To Mandate**: `noreply@` からの送信でも、`Reply-To` にサポート用アドレスを設定。
*   **Cross-Reference**: `600_security_privacy.md` — SPF/DKIM/DMARC、送信ドメイン分離

### 16.2. The Email Audit Schema Standard（メール送信監査スキーマ基準）
*   **Law**: 全システムメール送信を監査テーブルに記録すること。
*   **Recommended Schema**:

    | カラム | 型 | 説明 |
    |:-------|:---|:-----|
    | `id` | UUID | 一意識別子 |
    | `recipient_email` | TEXT (masked) | 送信先（マスキング保存: `a***z@...`） |
    | `template_type` | TEXT | テンプレート種別 |
    | `subject` | TEXT | 件名 |
    | `status` | TEXT | `sent`, `failed`, `bounced` |
    | `provider_id` | TEXT | 送信プロバイダの送信ID |
    | `sent_at` | TIMESTAMPTZ | 送信日時 |
    | `error_detail` | TEXT | 失敗時のエラー詳細 |

*   **PII Protection**: `recipient_email` はマスキング保存（PII直接保存禁止）。
*   **Retention**: 保持期間はBlueprint側で定義（推奨: 1年間）。期間後は自動削除。
*   **Cross-Reference**: `601_data_governance.md` §3 — Email Compliance Protocol

---

## Part XVII: コミュニティ・フォーラム戦略

### 17.1. The Community-Led Support Strategy（コミュニティ主導サポート戦略）
*   **Law**: ユーザーコミュニティをサポートエコシステムの重要な柱として構築・運用すること。
*   **Community Types**:

    | 種別 | 目的 | プラットフォーム例 |
    |:-----|:-----|:----------------|
    | **ヘルプフォーラム** | ユーザー同士のQ&A | Discourse, GitHub Discussions |
    | **フィーチャーリクエスト** | 機能要望の投票・議論 | Canny, ProductBoard |
    | **ベータテスター** | 新機能の先行テスト | 招待制グループ |
    | **チャンピオンプログラム** | 熱心なユーザーの育成・表彰 | 専用プログラム |
    | **ユーザーグループ** | 業種・地域別のネットワーキング | Meetup, オンラインイベント |
    | **開発者コミュニティ** | API/SDK利用者の技術交流 | Discord, Stack Overflow |

### 17.2. The Community Moderation Protocol（コミュニティモデレーション基準）
*   **Law**: コミュニティフォーラムには明確なガイドラインとモデレーション体制を構築すること。
*   **Community Guidelines（必須要素）**:
    *   許可される行動と禁止される行動の明確な定義
    *   個人情報の投稿禁止ルール
    *   ハラスメント・差別的表現の禁止
    *   スパム・自己宣伝の制限
    *   違反時の対処プロセス（警告 → 一時停止 → 永久BAN）
*   **Moderation Tools**:
    *   AIによるコンテンツ自動フラグ（不適切コンテンツの事前検出）
    *   ユーザーによる通報機能
    *   モデレーターダッシュボード（キュー管理）
*   **Response Time**: コミュニティ内の通報に対し、**24時間以内**にモデレーションアクションを完了すること。

### 17.3. The Champion Program Standard（チャンピオンプログラム基準）
*   **Law**: 熱心なユーザー（Champion/Advocate）を特定・育成し、コミュニティの自走力を高めること。
*   **Recognition**: バッジ、専用フォーラム、新機能の先行アクセス、年次イベント招待等のインセンティブ。
*   **Empowerment**: チャンピオンに一定のモデレーション権限やナレッジベース編集提案権を付与。
*   **Community Health Metrics**: コミュニティの健全性を以下の指標で追跡すること。
    *   月間アクティブ投稿者数
    *   質問への平均回答時間
    *   コミュニティ解決率（スタッフ介入なしの解決割合）
    *   新規メンバー定着率（登録後30日以内の投稿率）

---

## Part XVIII: Trust & Safety

### 18.1. The Trust & Safety Framework（Trust & Safetyフレームワーク）
*   **Law**: ユーザーの安全と信頼を守るための包括的なフレームワークを構築・運用すること。
*   **Scope**:
    *   不正利用（Abuse）の検出と対処
    *   有害コンテンツのモデレーション
    *   ユーザー間のハラスメント防止
    *   未成年者保護
    *   詐欺・スキャム防止
    *   AI生成コンテンツの識別・ラベリング
    *   Support Channel経由のSocial Engineering攻撃の検出・防止

### 18.2. The Content Moderation Standard（コンテンツモデレーション基準）
*   **Law**: UGC（User Generated Content）を含むサービスでは、多層的なコンテンツモデレーションを実装すること。
*   **Moderation Layers**:

    | レイヤー | 手法 | カバー範囲 |
    |:--------|:-----|:----------|
    | **L1: 自動フィルター** | キーワードフィルター、AIモデル | リアルタイム即時ブロック |
    | **L2: AI分類** | LLMによる文脈理解・分類 | ニュアンスのある有害コンテンツ |
    | **L3: 人間レビュー** | モデレーターによる判断 | AI判定が困難なケース |
    | **L4: ユーザー通報** | コミュニティによる通報 | 見逃されたコンテンツの補完 |

*   **Transparency Report**: モデレーションの実施状況（削除数、理由別内訳）を定期的に公開することを推奨。
*   **DSA Compliance**: EU市場向けサービスはDigital Services Act（DSA）のコンテンツモデレーション透明性要件に準拠すること。

### 18.3. The User Report & Appeal Protocol（通報・異議申し立て基準）
*   **Law**: ユーザーからの通報機能と、モデレーション判定に対する異議申し立てプロセスを提供すること。
*   **Report Flow**:
    1.  ユーザーが違反コンテンツを2クリック以内で通報
    2.  通報理由の選択（必須）+ 補足説明（任意）
    3.  24時間以内にモデレーション判定
    4.  アクション実行（警告/コンテンツ削除/アカウント停止）
    5.  通報者と対象者の双方に結果を通知
*   **Appeal Process**: モデレーション判定に不服がある場合、**7日以内**に異議申し立てが可能。別のモデレーターが再審査を行うこと。
*   **Cross-Reference**: `600_security_privacy.md` — ボット/DDoS防御、`601_data_governance.md` — 子供/脆弱者保護

### 18.4. The Support Channel Security Standard（サポートチャネルセキュリティ基準）
*   **Law**: サポートチャネルを経由したSocial Engineering攻撃を防止するセキュリティ対策を実装すること。
*   **Agent Identity Verification**: エージェントがアカウントの変更（メールアドレス変更、パスワードリセット等）を行う前に、ユーザーの本人確認を多要素で実施すること（登録メール確認 + セキュリティ質問 or アプリ内認証）。
*   **Social Engineering Detection**: AIが不審なリクエストパターン（急な連絡先変更要求、異常なアクセスパターン）を検出し、追加認証をトリガーすること。
*   **Sensitive Operation Lock**: アカウント削除、全データエクスポート等の高リスク操作は、サポートチャネルからの要求ではなくアプリ内の認証済みフローでのみ実行すること。

---

## Part XIX: サポートアクセシビリティ

### 19.1. The Support Accessibility Mandate（サポートアクセシビリティ義務）
*   **Law**: 全サポートチャネル（チャット、フォーム、ナレッジベース、コミュニティ）は**WCAG 2.2 Level AA**に準拠すること。
*   **EAA Compliance**: 欧州市場向けサービスは、European Accessibility Act（EAA, 2025年6月施行）の要件を満たすこと。
*   **Key Requirements**:
    *   スクリーンリーダー完全対応（ARIAラベル、セマンティックHTML）
    *   キーボードのみでの操作完結
    *   十分な色コントラスト比（4.5:1以上）
    *   フォーカスインジケーターの明示
    *   動画コンテンツへのキャプション・字幕付与
    *   代替テキスト（Alt Text）の全画像への付与
    *   タッチターゲットサイズ（最低 24x24px、推奨 44x44px）

### 19.2. The Accessible Communication Standard（アクセシブルコミュニケーション基準）
*   **Law**: サポート対応において、多様なニーズを持つユーザーに配慮したコミュニケーション手段を提供すること。
*   **Requirements**:
    *   テキストベースのチャットサポート（聴覚障害ユーザー対応）
    *   大きなフォントサイズ・ハイコントラストモードの提供
    *   Plain Language（平易な言葉）での記述（専門用語の排除）
    *   多言語対応（ターゲット市場の全言語）
    *   認知障害ユーザーへの配慮（シンプルなナビゲーション、明確なラベリング）
*   **Accessibility Testing**: サポートUI/UXの変更時に、アクセシビリティテスト（axe-core等）を必ず実施すること。
*   **Cross-Reference**: `200_design_ux.md` — WCAG 2.1 AA基準、アクセシビリティ

---

## Part XX: サポートオペレーション・チーム

### 20.1. The Support Team Structure Standard（サポートチーム構成基準）
*   **Law**: サポート組織を以下の階層で構成し、責務を明確化すること。

    | 階層 | 役割 | 責務 |
    |:-----|:-----|:-----|
    | **Tier 1** | フロントライン | 一般的な問い合わせ対応、FAQ誘導、チケット起票 |
    | **Tier 2** | スペシャリスト | 技術的問題の調査・解決、エスカレーション管理 |
    | **Tier 3** | エンジニアリング | バグ修正、インフラ対応、根本原因分析 |
    | **CS (Customer Success)** | CSM | プロアクティブ支援、Health Score管理、Expansion |
    | **Support Ops** | 運用担当 | ツール管理、データ分析、プロセス最適化 |

### 20.2. The Agent Training & Certification Protocol（エージェント教育・認定基準）
*   **Law**: サポートエージェントの継続的なスキル向上を制度化すること。
*   **Onboarding Training**: 新規エージェントは最低**2週間**のトレーニング期間を経てから独立対応を開始すること。
*   **Training Areas**:
    *   プロダクト知識（全機能の深い理解）
    *   コミュニケーションスキル（共感・デエスカレーション）
    *   ツール操作（サポートプラットフォーム、内部ツール）
    *   セキュリティ・プライバシー意識
    *   アクセシビリティ意識
    *   AI Copilot活用スキル
    *   Social Engineering攻撃の識別と対処
*   **Continuous Learning**: 月1回以上の定期トレーニング（プロダクトアップデート、ケーススタディ共有）を実施。
*   **Certification**: 四半期ごとのスキルアセスメントを実施し、基準未達のエージェントには追加トレーニングを提供。
*   **Shadowing Program**: 新人エージェントがベテランエージェントの対応を見学するシャドウイングプログラムを実施（最低1週間）。

### 20.3. The Agent Wellbeing Protocol（エージェントウェルビーイング基準）
*   **Law**: サポートエージェントの精神的健康と持続可能な働き方を保護すること。
*   **Burnout Prevention**:
    *   連続対応時間の上限設定（推奨: 2時間対応 + 15分休憩のサイクル）
    *   困難なケース（クレーム、ハラスメント）後のクールダウン時間の保証
    *   エスカレーションの心理的安全性（「助けを求める ≠ 弱さ」の文化）
*   **Toxic Interaction Shield**: 明らかに攻撃的・ハラスメント的なユーザーに対しては、エージェントが対応を中断し、マネージャーに引き継ぐ権利を保証すること。
*   **Wellbeing Metrics**: エージェントの離職率、満足度（eNPS）、バーンアウトリスクスコアを四半期ごとに計測し、改善施策を策定すること。
*   **Workload Balance**: AIによるチケット自動ルーティングで、特定エージェントへの負荷集中を防止すること。

---

## Part XXI: サポートQA・品質管理

### 21.1. The Support QA Framework（サポート品質保証フレームワーク）
*   **Law**: サポート品質を定量的に計測・管理するQAプログラムを運用すること。
*   **QA Scorecard（評価基準）**:

    | 評価項目 | ウェイト | 基準 |
    |:--------|:--------|:-----|
    | **正確性** | 30% | 回答が正しく、最新のドキュメントに基づいているか |
    | **共感性** | 20% | ユーザーの感情に寄り添った対応ができているか |
    | **効率性** | 15% | 必要最小限のやり取りで解決に導けたか |
    | **完全性** | 20% | 問題を完全に解決し、関連するリスクも予防できたか |
    | **プロセス遵守** | 15% | SLA・エスカレーション基準を遵守したか |

*   **Sampling Rate**: 全チケットの **≥ 5%** をランダムサンプリングしてQAレビューを実施すること。
*   **Calibration Session**: 月1回、QA評価者間の採点基準を擦り合わせるキャリブレーションセッションを実施。

### 21.2. The AutoQA & Conversation Intelligence Standard（AutoQA基準）
*   **Law**: AIを活用して全チケットの自動QAスコアリングを実施し、品質管理の網羅性を飛躍的に向上させること。
*   **AutoQA Coverage**: 全チケットの**100%**に対してAI QAスコアリングを適用すること（人間QAの5%サンプリングを補完）。
*   **AutoQA Dimensions**:
    *   回答の正確性（ナレッジベースとの整合性検証）
    *   トーン・共感性の評価
    *   SLA遵守の自動判定
    *   フォローアップの適切性
*   **Conversation Intelligence**: 全会話データを分析し、以下のインサイトを自動抽出すること。
    *   トップのフリクションポイント
    *   エージェントのスキルギャップ
    *   ベストプラクティス事例の自動発見
    *   AI回答品質のトレンド
*   **Low-Score Alert**: AutoQAスコアが閾値を下回ったチケットを自動的に人間レビューキューに回すこと。

### 21.3. The DSAT Analysis Protocol（不満足分析プロトコル）
*   **Law**: CSAT低スコア（1-2/5）のチケットは**全件**根本原因分析を実施すること。
*   **Root Cause Categories**: `product_issue` / `agent_error` / `process_gap` / `expectation_mismatch` / `sla_breach`
*   **Action Loop**: 分析結果を週次で集計し、トップ3の根本原因に対する改善アクションを策定・実行すること。
*   **Agent Performance Analytics**: エージェント個人レベルのパフォーマンス分析（CSAT、AHT、FCR、QAスコア）を可視化し、個別コーチング計画に活用すること。

---

## Part XXII: サポートFinOps

### 22.1. The Support Cost Optimization Protocol（サポートコスト最適化）
*   **Law**: サポートコストを可視化し、効率性とユーザー体験のバランスを最適化すること。
*   **Key Metrics**:

    | 指標 | 算出方法 | 目標 |
    |:-----|:--------|:-----:|
    | **Cost per Ticket (CPT)** | 総サポートコスト / チケット総数 | 業界平均以下 |
    | **Cost per Resolution (CPR)** | 総サポートコスト / 解決チケット数 | 継続的な改善 |
    | **AI Deflection Savings** | AI解決チケット数 × 平均CPT | 可視化・最大化 |
    | **Self-Service Savings** | セルフサービス解決数 × 平均CPT | 可視化・最大化 |
    | **Cost per AI Resolution** | AIインフラコスト / AI解決チケット数 | 人間CPRの1/5以下 |

*   **CPR Optimization Curve**: Resolution Rate vs Cost曲線を作成し、最適なAI/人間比率を特定すること。
*   **Budget Allocation**: サポート予算の配分（人件費 / ツール / AI / トレーニング）を四半期ごとに見直し、ROI最大化を追求すること。

### 22.2. The AI Support ROI Standard（AIサポートROI基準）
*   **Law**: AI導入のROIを以下の指標で継続的に計測すること。
*   **Efficiency Gain**: AI導入前後のCPT・平均解決時間の比較
*   **Quality Impact**: AI導入前後のCSAT・FCRの変化
*   **Token Cost Management**:
    *   AIモデルのトークン消費量・コストをリアルタイムで追跡
    *   コスト効率の悪いプロンプト（冗長なシステムプロンプト等）を最適化
    *   モデル別のコストパフォーマンスを比較し、最適なモデルを選定
    *   トークン予算の上限設定とアラート（月次予算の80%消費時点で通知）
*   **AI Token Budget Formula（推奨）**:
    ```
    月次AI予算 = (予測チケット数 × AI処理率 × 平均トークン数/チケット × トークン単価) × 1.2（バッファ係数）
    ```
*   **Cross-Reference**: `101_revenue_monetization.md` — AIトークンエコノミクス、FinOps

---

## Part XXIII: サポート分析・可観測性

### 23.1. The Support Analytics Dashboard Standard（サポート分析ダッシュボード基準）
*   **Law**: サポートのパフォーマンスをリアルタイムで可視化するダッシュボードを運用すること。
*   **Required Visualizations**:
    *   **リアルタイムキュー**: 未対応チケット数、待ち時間、チャネル別分布
    *   **SLA遵守率**: 優先度別のSLA遵守率（目標線付き）
    *   **エージェント稼働状況**: エージェント別の対応中/待機/離席ステータス
    *   **トレンド分析**: 問い合わせ量の時間帯別・曜日別トレンド
    *   **トピック分析**: 問い合わせカテゴリの分布と推移
    *   **CSAT/NPS推移**: 顧客満足度指標のトレンドチャート
    *   **AI Resolution Rate**: AIによる自律解決率のリアルタイムモニタリング
    *   **AI vs Human Performance**: AI/人間別の主要KPI比較

### 23.2. The Support Observability Standard（サポート可観測性基準）
*   **Law**: サポートシステムの健全性を可観測性の観点から監視すること。
*   **Monitoring Targets**:
    *   チャットボット応答時間・エラー率
    *   メール送信成功率・バウンス率
    *   ナレッジベースの検索ヒット率・ゼロ結果率
    *   AIモデルの分類精度・エスカレーション率
    *   サポートAPIのレイテンシ・エラー率
    *   AI Agent Tool Use成功率・レイテンシ
*   **Alerting**: 上記メトリクスが閾値を超えた場合、即座にアラートを発火すること。
*   **Cross-Reference**: `502_site_reliability.md` — 可観測性5本柱、`401_data_analytics.md` — 分析ダッシュボード品質基準

---

## Part XXIV: コンプライアンス・規制対応

### 24.1. The Customer Support Compliance Standard（サポートコンプライアンス基準）
*   **Law**: サポート業務において以下の規制・法令を遵守すること。
*   **Data Protection**:
    *   GDPR/APPI/CCPA等のデータ保護法に準拠した個人情報の取り扱い
    *   サポートチケット内のPIIの最小限保持・期限付き削除
    *   ユーザーからのデータアクセス要求・削除要求（DSR）への対応プロセス
*   **Consumer Rights**:
    *   解約の自由（ダークパターン禁止）
    *   苦情処理の法的義務への準拠
    *   返金ポリシーの明確な開示
*   **Accessibility Compliance**:
    *   WCAG 2.2 Level AA準拠（Part XIX参照）
    *   EAA（European Accessibility Act）準拠
    *   ADA（Americans with Disabilities Act）準拠
*   **AI Transparency**:
    *   EU AI Act準拠（AIサポートの利用開示義務）
    *   AIによる意思決定の説明可能性確保

### 24.2. The Data Subject Request Protocol（データ主体要求対応基準）
*   **Law**: ユーザーからのデータアクセス・削除・修正要求（DSR）に対し、法定期限内に対応すること。
*   **Response SLA**:
    *   GDPR: **30日以内**
    *   CCPA: **45日以内**
    *   APPI: **遅滞なく**
*   **Process**: サポートチームがDSRを受領した場合、専用のワークフローを通じてデータ保護チームにルーティングすること。
*   **Cross-Reference**: `601_data_governance.md` — GDPR/APPI/CCPA準拠、データ主体の権利

---

## Part XXV: Voice AI & Conversational Support

### 25.1. The Voice AI Agent Standard（Voice AIエージェント基準）
*   **Law**: 電話サポートにおいてVoice AIエージェントを導入し、自律的な問題解決を実現すること。
*   **Capability Requirements**:
    *   自然言語理解（NLU）による意図検出精度 **≥ 95%**
    *   マルチターン会話の文脈維持
    *   感情認識と適切なトーン調整
    *   リアルタイム音声認識（ASR）とテキスト変換
    *   多言語対応（ターゲット市場の全言語）
*   **Resolution Target**: Voice AIによる自律解決率 **≥ 60%**。
*   **Handoff Design**: Voice AIが解決できない場合のシームレスな人間エージェントへの引き継ぎを設計すること。会話コンテキストの完全転送を義務化。

### 25.2. The IVR Modernization Standard（IVR近代化基準）
*   **Law**: 従来型のメニューベースIVR（Interactive Voice Response）からConversational IVRへの移行を推進すること。
*   **Anti-Pattern**: 深いメニュー階層（3階層超）をもつ従来型IVRは禁止。
*   **Requirements**:
    *   自然言語による要望聴取（「ご用件をお話しください」）
    *   予想待ち時間の告知
    *   コールバック予約オプションの提供
    *   Visual IVR（スマートフォン画面でのメニュー表示）のサポート

### 25.3. The Speech Analytics Standard（音声分析基準）
*   **Law**: 全通話音声を分析し、品質改善・コンプライアンス確認に活用すること。
*   **Required Analytics**:
    *   センチメント分析（リアルタイム感情検出）
    *   キーワード・トピック検出
    *   コンプライアンス用語の検出（スクリプト遵守確認）
    *   沈黙・保留時間の分析
    *   エージェントのトーン・速度分析
*   **Privacy**: 通話録音に関する法的要件（同意取得義務）を遵守すること。

### 25.4. The Conversational AI Safety Standard（会話型AI安全基準）
*   **Law**: Voice AI・チャットAIにおいて、LLMの安全性ガードレールを実装すること。
*   **Guard Layer Architecture**:

    | レイヤー | 機能 | 実装 |
    |:--------|:-----|:-----|
    | **Input Guard** | プロンプトインジェクション検出 | 入力フィルタリング + パターン検出 |
    | **System Prompt Protection** | システムプロンプトの漏洩防止 | プロンプト分離 + 暗号化 |
    | **Output Guard** | 有害・不適切コンテンツの出力防止 | 出力フィルタリング + Content Safety API |
    | **Topic Guard** | サポート範囲外トピックの拒否 | トピック分類 + ブロックリスト |
    | **PII Guard** | 個人情報の出力防止 | PII検出 + マスキング |

*   **Red Team Testing**: AIサポートシステムに対し、四半期ごとにRed Team Testing（敵対的テスト）を実施し、脆弱性を特定・修正すること。
*   **Cross-Reference**: `400_ai_engineering.md` — ガードレール設計、`600_security_privacy.md` — セキュリティ基準

---

## Part XXVI: ハイパーパーソナライゼーション戦略

### 26.1. The Hyper-Personalization Framework（ハイパーパーソナライゼーション基盤）
*   **Law**: AI駆動のハイパーパーソナライゼーションにより、全サポートインタラクションを個別最適化すること。
*   **Personalization Layers**:

    | レイヤー | 内容 | データソース |
    |:--------|:-----|:-----------|
    | **コンテキスト** | 現在の画面・状態・直前の操作 | アプリイベント |
    | **行動履歴** | 過去の利用パターン・チケット履歴 | 行動ログ |
    | **セグメント** | プラン・業種・地域 | CRM/CDP |
    | **嗜好** | 通知設定・チャネル選好・言語 | ユーザー設定 |
    | **予測** | 解約リスク・Expansion可能性 | MLモデル |

### 26.2. The Next-Best-Action Engine（ネクストベストアクション基準）
*   **Law**: 全サポートタッチポイントにおいて、AIによるNext-Best-Action（最適次善策）を提示すること。
*   **Action Types**:
    *   リアルタイムな記事・チュートリアルサジェスト
    *   パーソナライズされたオンボーディングステップ
    *   セグメント別のUpsell/Cross-sellオファー
    *   プロアクティブなリスク軽減アクション
    *   Next-Best-Offer: 利用パターンに基づく最適なプランアップグレード提案
*   **Anti-Pattern**: 全ユーザーに同じ案内を表示する「One-Size-Fits-All」アプローチは禁止。
*   **Propensity Model Integration**: Propensity Score（購買傾向スコア）と連携し、Expansion可能性の高い顧客にのみオファーを表示すること。

### 26.3. The Customer Data Platform Integration（CDP連携基準）
*   **Law**: サポートシステムをCustomer Data Platform（CDP）と統合し、360度の顧客ビューを実現すること。
*   **Required Data Points**:
    *   プロダクト利用データ（機能別利用状況、セッション時間）
    *   サポート履歴（全チケット履歴、解決率）
    *   契約・課金データ（プラン、請求状況、MRR）
    *   マーケティングエンゲージメント（メール開封率、イベント参加）
*   **Privacy**: CDP内の個人データは `601_data_governance.md` の同意管理・データ保護規定に準拠すること。

---

## Part XXVII: デジタルカスタマーサクセス (Digital CS)

### 27.1. The Digital CS Strategy（デジタルCS戦略基盤）
*   **Law**: テックタッチ/ロータッチセグメントに対し、完全自動化されたデジタルCSプログラムを構築すること。
*   **Digital CS Playbook**:

    | フェーズ | 自動化アクション | チャネル | タイミング |
    |:--------|:---------------|:--------|:---------|
    | **オンボーディング** | ウェルカムシリーズ、チェックリスト | In-App + Email | Day 0-30 |
    | **アダプション** | 機能ガイド、ベストプラクティス | In-App | Day 30-90 |
    | **エンゲージメント** | 利用Tips、新機能案内 | In-App + Email | 継続的 |
    | **リテンション** | リスクアラート、リエンゲージメント | Email + In-App | トリガーベース |
    | **Expansion** | アップグレード案内、利用量アラート | In-App | トリガーベース |

*   **PLG Integration**: Product-Led Growth（PLG）戦略と連携し、プロダクト内体験をCSの主要チャネルとすること。
*   **Usage-Based Triggers**: Usage-Based Pricing（UBP）モデルの場合、利用量の閾値に応じた自動化トリガーを設定すること。

### 27.2. The Digital Adoption Platform Integration（DAP統合基準）
*   **Law**: Digital Adoption Platform（DAP）を活用し、プロダクト内での自律的な学習・活用を促進すること。
*   **DAP Capabilities**:
    *   コンテキストに応じたIn-Appウォークスルー
    *   インタラクティブなガイドツアー
    *   Smart Tips（ツールチップの高度版）
    *   Feature Discovery（未利用機能のハイライト）
    *   パーソナライズされたチェックリスト
*   **Requirements**:
    *   ユーザーセグメント別のパーソナライズされたメッセージ
    *   トリガーベースの表示（特定のイベント・行動に基づく）
    *   A/Bテストによる効果測定と最適化
    *   表示頻度の制御（過度な表示の防止: 同一ガイドは24時間に1回まで）

### 27.3. The Automated QBR Standard（自動化QBR基準）
*   **Law**: ミッドタッチ以下のセグメントに対し、Quarterly Business Review（QBR）を自動化すること。
*   **Digital QBR Contents**:
    *   利用状況サマリー（主要KPIの推移）
    *   ROI計算（コスト削減・生産性向上の定量化）
    *   未利用機能のレコメンデーション
    *   ベンチマーク比較（同業種平均との比較）
    *   次四半期のアクションプラン提案
*   **Delivery**: パーソナライズされたダッシュボードURL、またはインタラクティブPDFで配信。

---

## Part XXVIII: CS Revenue Accountability

### 28.1. The CS Revenue Framework（CS収益フレームワーク）
*   **Law**: CSチームにNet Revenue Retention（NRR）の責任を明確に割り当て、収益貢献を定量化すること。
*   **Key Revenue Metrics**:

    | 指標 | 定義 | 目標 |
    |:-----|:-----|:-----|
    | **NRR (Net Revenue Retention)** | 既存顧客からの収益維持・拡大率 | ≥ 110% |
    | **GRR (Gross Revenue Retention)** | 解約による収益減少を除いた維持率 | ≥ 90% |
    | **Expansion Revenue** | 既存顧客からのアップセル・クロスセル収益 | 新規ARRの30%以上 |
    | **Churn Saved Revenue** | リテンション施策により防いだ解約額 | 可視化・最大化 |
    | **Support-Influenced ARR** | サポート接点がExpansionに寄与したARR | 追跡・可視化 |

*   **CS-Led Growth**: CSチームをRevenue Engineering機能として位置づけ、Expansion戦略の策定・実行を主導させること。

### 28.2. The CS Qualified Lead (CSQL) Standard（CSQL基準）
*   **Law**: CSチームが特定したExpansion/Upsell機会をCSQLとしてセールスチームにハンドオフするプロセスを定義すること。
*   **CSQL Criteria**:
    *   Health Score ≥ 80（Healthy）
    *   利用量がプラン上限の70%超
    *   チャンピオンユーザーからのポジティブフィードバック
    *   更新時期が90日以内
    *   **Product Qualified Signals（PQS）**: 特定の機能利用パターンがExpansionシグナル
*   **Handoff Process**: CSQLをCRM（Salesforce/HubSpot等）に登録し、セールスチームとの定期的な合同レビューを実施すること。
*   **Consumption-Based Expansion**: UBPモデルの場合、利用量トレンドに基づく予測的なアップグレード推奨を自動化すること。

### 28.3. The Renewal Management Standard（更新管理基準）
*   **Law**: 契約更新プロセスを体系化し、更新率 **≥ 95%** を目標とすること。
*   **Renewal Timeline**:
    *   **T-120日**: 更新前レビュー開始、Health Scoreチェック
    *   **T-90日**: 更新プランの提案・値上げ交渉（該当する場合）
    *   **T-60日**: 更新条件の合意
    *   **T-30日**: 契約書の準備・送付
    *   **T-0日**: 更新完了
*   **At-Risk Renewal Playbook**: Health Scoreが低い顧客の更新に対し、専用のリテンションプレイブックを準備すること。

---

## Part XXIX: プロアクティブサポート設計

### 29.1. The Proactive Support Framework（プロアクティブサポート基盤）
*   **Law**: 問い合わせが来る**前に**問題を検知・解決するプロアクティブサポート体制を構築すること。
*   **Proactive Intervention Types**:

    | 種別 | トリガー | アクション |
    |:-----|:--------|:---------|
    | **障害先行告知** | インシデント検知 | 影響ユーザーへの事前通知 |
    | **利用ガイダンス** | 機能未活用の検知 | パーソナライズされたTipsの表示 |
    | **リスク介入** | Health Score低下 | CSMによるアウトリーチ |
    | **予防的メンテナンス** | 利用量の急増 | スケーリング推奨・プランアップグレード案内 |
    | **品質アラート** | エラー率の上昇 | 自動診断レポートの送信 |

### 29.2. The Predictive Issue Resolution Standard（予測的問題解決基準）
*   **Law**: ML/AIを活用してユーザーが問題に直面する前に予測・解決すること。
*   **Data Sources**: アプリエラーログ、性能メトリクス、利用パターンの異常検知
*   **Automated Resolution**: 既知の問題パターンに対しては、自動修復（Self-Healing）を実装すること。
*   **Notification**: 問題を検知・自動修復した場合、ユーザーに事後通知すること（「問題を検知し、自動的に修正しました」）。

### 29.3. The Incident Communication Standard（インシデントコミュニケーション基準）
*   **Law**: サービス障害時にプロアクティブかつ透明なコミュニケーションを行うこと。
*   **Communication Timeline**:
    *   **T+5分**: ステータスページの更新
    *   **T+15分**: 影響ユーザーへのアプリ内/メール通知
    *   **T+30分ごと**: 進捗アップデート
    *   **解決後**: 根本原因のポストモーテム公開
*   **Cross-Reference**: `503_incident_response.md` — インシデントコミュニケーションプロトコル

---

## Part XXX: カスタマージャーニーオーケストレーション

### 30.1. The Journey Mapping Standard（ジャーニーマッピング基準）
*   **Law**: 顧客ライフサイクル全体をジャーニーマップとして可視化し、各タッチポイントでの最適な体験を設計すること。
*   **Lifecycle Phases**:
    1.  **認知 (Awareness)** → 2. **検討 (Consideration)** → 3. **導入 (Onboarding)** → 4. **活用 (Adoption)** → 5. **拡大 (Expansion)** → 6. **更新 (Renewal)** → 7. **推奨 (Advocacy)**
*   **Touchpoint Design**: 各フェーズでのサポート/CSのタッチポイント、チャネル、コンテンツを定義すること。

### 30.2. The Lifecycle Automation Standard（ライフサイクル自動化基準）
*   **Law**: ジャーニーの各フェーズ移行時に自動化されたアクションをトリガーすること。
*   **Automation Triggers**:
    *   フェーズ移行（例: オンボーディング完了 → 活用フェーズ）
    *   時間ベース（例: 利用開始30日後）
    *   行動ベース（例: 特定の機能を初回利用）
    *   リスクベース（例: Health Score低下）

### 30.3. The Moment of Truth Design（真実の瞬間設計基準）
*   **Law**: 顧客ロイヤルティに決定的な影響を与える「真実の瞬間（Moment of Truth）」を特定し、卓越した体験を設計すること。
*   **Critical Moments**:
    *   **初回値体験**: 最初の「Aha! Moment」
    *   **初回問い合わせ**: サポートの初回体験
    *   **重大障害**: サービス障害時の対応体験
    *   **契約更新**: 更新判断の瞬間
    *   **解約検討**: 解約を考えた瞬間

---

## Part XXXI: サポートナレッジマネジメント (KCS)

### 31.1. The Knowledge-Centered Service Standard（KCS基準）
*   **Law**: Knowledge-Centered Service（KCS）方法論を採用し、サポート対応のプロセスの中でナレッジを継続的に生成・更新すること。
*   **KCS Principles**:
    *   **Capture**: 問題解決時にナレッジを即座にキャプチャ
    *   **Structure**: 統一フォーマットでの構造化
    *   **Reuse**: 既存ナレッジの再利用を優先
    *   **Improve**: 利用のたびにナレッジを改善

### 31.2. The Knowledge Quality Metrics Standard（ナレッジ品質指標基準）
*   **Law**: ナレッジベースの品質を以下の指標で計測すること。

    | 指標 | 定義 | 目標 |
    |:-----|:-----|:-----|
    | **Reuse Rate** | 既存記事の再利用率 | ≥ 60% |
    | **Article Resolution Rate** | 記事閲覧後のチケット起票回避率 | ≥ 50% |
    | **Freshness Score** | 90日以内に更新された記事の割合 | ≥ 80% |
    | **Feedback Score** | 「役に立った」評価率 | ≥ 75% |
    | **Zero Results Rate** | 検索結果0件の割合 | ≤ 10% |
    | **AI Citation Accuracy** | AIが記事を正しく引用した割合 | ≥ 95% |

### 31.3. The AI-Assisted Knowledge Generation Standard（AI支援ナレッジ生成基準）
*   **Law**: AIを活用してナレッジ生成を効率化すること。
*   **Capabilities**:
    *   解決済みチケットからの記事ドラフト自動生成
    *   既存記事の自動要約・簡略化
    *   多言語自動翻訳（人間レビュー付き）
    *   記事の古さ検出と更新推奨
    *   Knowledge Graph構築: 記事間の関連性をグラフ構造で管理し、AIの回答精度を向上
    *   Semantic Search: ベクトル検索を活用し、類似概念の検索精度を向上させること

---

## Part XXXII: 多言語・グローバルサポート設計

### 32.1. The Global Support Architecture（グローバルサポートアーキテクチャ）
*   **Law**: 複数地域・多言語でのサポート提供体制を設計すること。
*   **Follow-the-Sun Model**: グローバルチームを活用し、24時間対応を実現するFollow-the-Sunモデルを推奨。
*   **Regional SLA**: 地域ごとのビジネスアワー、法的要件に対応した個別SLAを定義。

### 32.2. The Multilingual Support Standard（多言語サポート基準）
*   **Law**: ターゲット市場の全言語でサポートを提供すること。
*   **Translation Quality Tiers**:

    | ティア | 用途 | 品質基準 |
    |:------|:-----|:--------|
    | **Tier 1: 人間翻訳** | 法的文書、契約、ポリシー | 専門翻訳者によるレビュー |
    | **Tier 2: AI翻訳 + 人間レビュー** | ナレッジベース記事、重要メール | AI翻訳後に母語話者がレビュー |
    | **Tier 3: リアルタイムAI翻訳** | ライブチャット、低優先度対応 | AI翻訳のみ（品質モニタリング付き） |

*   **Language Detection**: チャットやフォームでの言語自動検出と切り替えを実装すること。
*   **Real-time Translation API Integration**: サポートプラットフォームにリアルタイム翻訳API（Google Translate API、DeepL API等）を統合し、多言語対応のスケーラビリティを確保すること。
*   **Translation Memory**: 翻訳メモリ（TM）を活用し、一貫性のある翻訳品質を維持しつつコストを削減すること。
*   **Cross-Reference**: `802_language_protocol.md` — 多言語対応プロトコル

### 32.3. The Cultural Sensitivity Standard（文化的配慮基準）
*   **Law**: 地域ごとの文化的差異に配慮したコミュニケーションを行うこと。
*   **Considerations**:
    *   敬語レベルの調整（日本語のフォーマリティ）
    *   時間帯・祝日の考慮
    *   通貨・日付フォーマットのローカライズ
    *   色やアイコンの文化的解釈差異への配慮

---

## Part XXXIII: カスタマーエフォートスコア最適化

### 33.1. The Friction Mapping Framework（フリクションマッピング基盤）
*   **Law**: ユーザーがサポートに到達し、問題を解決するまでのフリクション（摩擦）ポイントを体系的にマッピング・排除すること。
*   **Friction Points Analysis**:
    *   サポートへのアクセス経路の複雑さ
    *   問い合わせフォームの入力項目数
    *   待ち時間（初回応答、解決）
    *   チャネル切り替えの頻度
    *   同じ説明の繰り返し回数

### 33.2. The Effortless Experience Design Standard（エフォートレス体験設計基準）
*   **Law**: すべてのサポートインタラクションにおいて、ユーザーのエフォート（手間）を最小化する設計を実装すること。
*   **Design Principles**:
    *   **Proactive > Reactive**: 問い合わせを待つより先に解決
    *   **Self-Service > Agent**: 人間を介さず解決できるパスを優先
    *   **AI > Manual**: AIで自動化できるものは自動化
    *   **Single Contact > Multiple**: 1回のコンタクトで解決

---

## Part XXXIV: サポートAI安全性・倫理基準

### 34.1. The AI Transparency Mandate（AI透明性義務）
*   **Law**: ユーザーがAIと対話していることを常に明示すること。
*   **Disclosure Requirements**:
    *   チャットの冒頭で「AIアシスタントです」と明示
    *   AI生成コンテンツにラベルを付与
    *   人間エージェントへの切り替えオプションを常時提示
*   **Anti-Pattern**: AIを人間エージェントに偽装する行為は厳禁。

### 34.2. The AI Bias Prevention Standard（AIバイアス防止基準）
*   **Law**: AIサポートシステムにおけるバイアスを防止・監視すること。
*   **Monitoring**:
    *   言語・地域・人種による対応品質の差異を定期的に監査
    *   AIの回答における偏見の有無を月次でレビュー
    *   多様なデモグラフィックでのテスト実施

### 34.3. The EU AI Act Compliance Standard（EU AI Act対応基準）
*   **Law**: EU市場向けサービスにおいて、EU AI Act（人工知能法）の要件を満たすこと。
*   **Risk Classification**: カスタマーサポートAIは通常「Limited Risk」に分類。透明性義務が適用。
*   **Article 50 Compliance Checklist**:
    *   ☐ AI利用の開示義務を実装（チャットボット開始時にAIであることを通知）
    *   ☐ AI生成コンテンツのラベリング（画像・テキスト・音声の全AI出力にラベル付与）
    *   ☐ 人間による監督メカニズムの実装（Human-in-the-Loop）
    *   ☐ AIの意思決定プロセスの説明可能性確保
    *   ☐ ユーザーからの人間対応要求権の保証
    *   ☐ AIシステムの定期的なリスク評価（年次以上）
    *   ☐ 技術文書の保持（AIモデルの目的・機能・限界の記録）
*   **GPAI Obligations（2025年8月施行）**: General Purpose AI（GPAI）モデルをサポートに利用する場合:
    *   モデルの技術文書の保持義務
    *   著作権法遵守のための訓練データの透明性確保
    *   EU AI Officeへの報告義務（システミックリスクモデルの場合）
*   **Penalties**: 違反時の制裁金は全世界年間売上高の最大 **7%** またはEUR 35Mのいずれか高い方。
*   **Cross-Reference**: `601_data_governance.md` — EU AI Act詳細

### 34.4. The Responsible AI in Support Framework（責任あるAI活用フレームワーク）
*   **Law**: AIサポートの開発・運用において以下の倫理原則を遵守すること。
*   **Principles**:
    *   **Fairness**: 全ユーザーに公平な品質のサポートを提供
    *   **Accountability**: AI判断の責任の所在を明確化
    *   **Transparency**: AI動作の説明可能性を確保
    *   **Privacy**: データ最小化原則の遵守
    *   **Safety**: ユーザーに害を与えない出力の保証
    *   **Human Control**: 重要な判断における人間の最終決定権の保持

---

## Part XXXV: Outcome-Based Support Pricing

### 35.1. The Outcome-Based Pricing Framework（成果ベース課金フレームワーク）
*   **Law**: AIサポートツールの導入・運用において、Outcome-Based Pricing（成果ベース課金）モデルを評価・導入すること。
*   **Pricing Models Comparison**:

    | モデル | 課金基準 | メリット | リスク |
    |:------|:--------|:--------|:------|
    | **Per-Seat** | エージェント数 | コスト予測可能 | AI活用のインセンティブ低下 |
    | **Per-Ticket** | チケット数 | 利用量に比例 | Deflectionのインセンティブ低下 |
    | **Per-Resolution** | 解決数 | 成果連動 | 品質が落ちる可能性 |
    | **Platform Fee + Resolution** | 固定費 + 解決数 | バランス型 | 推奨モデル |

### 35.2. The AI Vendor Selection Standard（AIベンダー選定基準）
*   **Law**: AIサポートベンダーの選定において以下の評価軸を用いること。
*   **Evaluation Criteria**:
    *   解決率（Resolution Rate）の実績
    *   ハルシネーション率
    *   多言語対応能力
    *   既存スタックとの統合容易性
    *   データプライバシー・セキュリティ準拠
    *   Outcome-Based Pricingの対応有無
    *   SLA（ベンダー側の稼働率保証）
    *   EU AI Act準拠状況

---

## Part XXXVI: ワークフォースマネジメント (WFM)

### 36.1. The Workforce Management Framework（WFMフレームワーク）
*   **Law**: サポートチームの要員計画・シフト管理を科学的に行うこと。
*   **Forecasting**: 過去の問い合わせ量データに基づき、時間帯別・曜日別・季節別の需要予測を実施。
*   **AI-Powered Scheduling**: AIが需要予測とエージェントのスキル・稀好を考慮し、最適なシフトスケジューリングを自動生成すること。
*   **Real-time Adherence**: リアルタイムのスケジュール遵守率モニタリング。

### 36.2. The Skill-Based Routing Standard（スキルベースルーティング基準）
*   **Law**: 問い合わせの内容に応じて、最適なスキルセットを持つエージェントに自動ルーティングすること。
*   **Skill Matrix**: エージェントごとのスキルセット（言語、技術領域、プロダクト知識）をプロファイリング。
*   **Intelligent Routing**: AIがチケット内容を分析し、スキルマッチングに基づいてルーティング。
*   **Load Balancing**: エージェント間の作業量を均等に分散するアルゴリズムの実装。
*   **Sentiment-Based Routing**: ユーザーのセンチメントが「怒り」と検出された場合、デエスカレーション専門のエージェントに自動ルーティングすること。

### 36.3. The Capacity Planning Standard（キャパシティプランニング基準）
*   **Law**: サポートチームのキャパシティを計画的に管理すること。
*   **Metrics**:
    *   **Occupancy Rate**: エージェントの稼働率（目標: 75-85%）
    *   **Utilization Rate**: 対応業務に費やした時間の割合
    *   **Shrinkage**: トレーニング・休憩等の非対応時間の割合
*   **Planning Horizon**: 月次の短期計画 + 四半期の中期計画 + 年次の長期計画
*   **Gig Worker Integration**: ピーク時の一時的なサポート需要に対し、Gig Worker（フリーランスエージェント）の活用プロセスを定義すること。品質基準・セキュリティ要件はフルタイムエージェントと同等を維持。

---

## Part XXXVII: サポート技術スタック設計

### 37.1. The Support Tech Stack Architecture（サポート技術スタックアーキテクチャ）
*   **Law**: サポート技術スタックを統合的に設計し、データサイロを防止すること。
*   **Core Components**:

    | コンポーネント | 役割 | 代表的ツール例 |
    |:------------|:-----|:-------------|
    | **ヘルプデスク** | チケット管理の中核 | Zendesk, Intercom, Freshdesk |
    | **チャットボット** | AI自動応答 | Intercom Fin, Zendesk AI, custom LLM |
    | **ナレッジベース** | セルフサービスコンテンツ | Zendesk Guide, Notion, GitBook |
    | **CRM** | 顧客データ管理 | Salesforce, HubSpot |
    | **CDP** | 統合顧客データ | Segment, mParticle |
    | **分析** | メトリクス可視化 | Metabase, Looker, Tableau |
    | **WFM** | 要員管理 | NICE, Assembled |
    | **QA** | 品質管理 | Klaus, MaestroQA |
    | **DAP** | プロダクト内ガイド | Pendo, WalkMe, Appcues |
    | **CS Platform** | CS運用 | Gainsight, Totango, ChurnZero |

### 37.2. The Integration Architecture Standard（統合アーキテクチャ基準）
*   **Law**: サポートツール間のデータ連携をAPIベースで設計し、シームレスなデータフローを実現すること。
*   **Integration Requirements**:
    *   ヘルプデスク ↔ CRM の双方向同期
    *   チャットボット ↔ ナレッジベース のリアルタイム参照
    *   サポートデータ → 分析ツール のストリーミング
    *   CDP → ヘルプデスク のコンテキスト注入
*   **Data Flow**: サポートインタラクションデータは、リアルタイムイベントストリーム（Webhook/Event Bus）で関連システムに伝播すること。

### 37.3. The Support Channel Security Architecture（サポートチャネルセキュリティアーキテクチャ）
*   **Law**: サポートシステムのセキュリティを多層防御で設計すること。
*   **Security Layers**:
    *   **認証**: SSO/MFA によるエージェントアクセス管理
    *   **権限制御**: RBACによる最小権限の原則（PII閲覧は認定エージェントのみ）
    *   **暗号化**: 通信（TLS 1.3）およびデータ保存時の暗号化
    *   **監査ログ**: エージェントの全操作を監査ログに記録
    *   **DLP**: データ漏洩防止（PII含むチケット内容の外部コピー防止）
*   **Cross-Reference**: `600_security_privacy.md` — セキュリティ基準

---

## Part XXXVIII: カスタマーアドボカシー・ロイヤルティ

### 38.1. The Customer Advocacy Framework（カスタマーアドボカシー基盤）
*   **Law**: 満足度の高い顧客をブランドの推奨者（Advocate）として育成・活用すること。
*   **Advocacy Programs**:

    | プログラム | 内容 | インセンティブ |
    |:---------|:-----|:-------------|
    | **紹介プログラム** | 友人・知人の紹介 | 紹介報酬（クレジット、ディスカウント） |
    | **ケーススタディ** | 成功事例の共同作成 | 露出機会、共同マーケティング |
    | **レビュー依頼** | G2/Capterra等でのレビュー投稿 | ギフトカード、限定特典 |
    | **スピーカー** | カンファレンス・ウェビナーでの登壇 | チケット提供、共同PR |
    | **ユーザーボード** | 製品開発への参画 | 先行アクセス、意思決定への影響力 |

### 38.2. The Referral Program Standard（紹介プログラム基準）
*   **Law**: 紹介プログラムを体系的に設計・運用すること。
*   **Requirements**:
    *   簡単な紹介フロー（ワンクリック招待リンク生成）
    *   双方向インセンティブ（紹介者と被紹介者の両方に特典）
    *   追跡・計測の自動化（紹介経由のコンバージョン追跡）
    *   不正防止（自己紹介、重複紹介の検出）

---

## Part XXXIX: 将来展望・新興技術

### 39.1. The Emerging Technology Watch（新興技術ウォッチ）
*   **Law**: サポート・CS領域の新興技術を継続的にウォッチし、実験・導入の計画を策定すること。
*   **Watch Areas (2025-2027)**:

    | 技術 | 適用領域 | 成熟度 |
    |:-----|:--------|:------|
    | **AR/VRサポート** | 製品の3Dガイド、リモートアシスト | 実験段階 |
    | **デジタルツイン** | 顧客環境の仮想レプリカによる診断 | 初期段階 |
    | **Spatial Computing** | ヘッドセット型サポートUI | 初期段階 |
    | **Emotion AI** | リアルタイム感情認識と対応調整 | 成長段階 |
    | **Autonomous CS Agents** | 完全自律型CS問題解決エージェント | 成長段階 |
    | **予測的サポート** | 問題発生前のAI予測・自動修復 | 成熟段階 |
    | **Ambient Computing** | ウェアラブル・IoTデバイス経由のサポート | 初期段階 |
    | **Multi-Agent Systems** | 複数AIエージェントの協調によるEnd-to-End解決 | 成長段階 |

### 39.2. The Innovation Experimentation Protocol（イノベーション実験基準）
*   **Law**: 新技術の導入においては、段階的な実験プロセスを経ること。
*   **Process**:
    1.  **PoC (Proof of Concept)**: 小規模な概念実証
    2.  **Pilot**: 限定ユーザーでのパイロット運用
    3.  **Limited GA**: 段階的なロールアウト
    4.  **Full GA**: 全ユーザーへの展開

---

## Part XL: 成熟度モデル・逆引き索引

### 40.1. The Support Maturity Model（サポート成熟度モデル）

| レベル | 名称 | 特徴 |
|:------|:-----|:-----|
| **L1: Reactive** | 受動的 | 問い合わせベースの対応のみ。SLA未定義。ナレッジベースなし。 |
| **L2: Defined** | 定義済み | SLA定義済み。基本的なFAQ/ナレッジベース。チケット分類の手動運用。 |
| **L3: Managed** | 管理的 | オムニチャネル統合。AIトリアージ導入。QAプログラム運用。VoC収集の体系化。 |
| **L4: Proactive** | 予見的 | Customer Health Score運用。予兆検知とプロアクティブ介入。Agentic AIサポート。コミュニティ自走。Digital CS運用。 |
| **L5: Optimized** | 最適化 | 予測的分析による完全自動化。Support-Influenced ARRの可視化。NRR ≥ 110%。AI Autonomous Resolution ≥ 80%。継続的な実験と最適化。 |

*   **Assessment**: 四半期ごとに成熟度レベルを自己評価し、次のレベルへのロードマップを策定すること。

### 40.2. アンチパターン集

| # | アンチパターン | 正しいアプローチ |
|:--|:-------------|:---------------|
| 1 | **Black Hole Support**: フィードバックを受けるが何も反映しない | Close the Loop（ループを閉じる義務） |
| 2 | **Runaround Escalation**: たらい回しで解決しない | 権限委譲 + FCR最大化 |
| 3 | **Cold AI Response**: AI任せの温かみのない回答 | Human-in-the-Loop + AI Copilot |
| 4 | **Dark Pattern Cancellation**: 解約を意図的に困難にする | 3ステップ解約 + Anti-Dark Pattern |
| 5 | **Survey Fatigue**: アンケートの過剰表示 | 7日間最大1回のスロットリング |
| 6 | **Context Loss Handoff**: チャネル切り替え時のコンテキスト消失 | オムニチャネル統合 + Unified Customer View |
| 7 | **Silent Ghost Feature**: フォーム送信後のフィードバックなし | Auto-Reply Mandate |
| 8 | **Support Silo**: サポートデータをプロダクト改善に活用しない | Support-Driven Development |
| 9 | **One-Size-Fits-All**: 全顧客に同じサポートモデル | セグメント別タッチモデル |
| 10 | **Agent Burnout**: エージェントの過度な負荷 | ウェルビーイングプロトコル |
| 11 | **AI Impersonation**: AIを人間に偽装する | AI透明性義務 |
| 12 | **Knowledge Hoarding**: ナレッジの属人化 | KCS（Knowledge-Centered Service） |
| 13 | **Hallucination Tolerance**: AI幻覚を放置する | Grounding + Citation義務 + AutoQA |
| 14 | **Tool Use Without Audit**: AIのTool Use実行を監査しない | Audit Trail + Dry Runモード |

---

## Appendix A: 逆引き索引

| キーワード | 参照セクション |
|:---------|:-------------|
| AI Copilot | 2.4 |
| AI トリアージ | 2.1 |
| AI 品質保証 | 2.6 |
| AI 安全性・倫理 | 34.1-34.4 |
| AI Tool Use | 2.3 |
| AI Agent Observability | 2.6 |
| Agentic AI | 2.2 |
| AutoQA | 21.2 |
| CDP連携 | 26.3 |
| CSAT | 12.2 |
| CES | 12.3, 33.1-33.2 |
| CSQL | 28.2 |
| CS-Led Growth | 28.1 |
| Customer Education | 9.4 |
| Customer Health Score | 8.1, 8.2 |
| DAP | 27.2 |
| Digital CS | 27.1-27.3 |
| DSR | 24.2 |
| EU AI Act | 34.3 |
| Gig Worker | 36.3 |
| Grounding | 2.5 |
| IVR | 25.2 |
| KCS | 31.1-31.3 |
| Knowledge Graph | 31.3 |
| MCP/A2A | 2.3 |
| NPS | 12.1 |
| NRR | 28.1 |
| Outcome-Based Pricing | 35.1 |
| PLG | 27.1 |
| Propensity Scoring | 8.2, 26.2 |
| Prompt Injection Defense | 2.5, 25.4 |
| SLA | 4.1 |
| Social Engineering | 18.4 |
| Support Excellence Culture | 1.5 |
| Token Cost Management | 22.2 |
| Trust & Safety | 18.1-18.4 |
| VoC | 11.1 |
| Voice AI | 25.1-25.4 |
| WFM | 36.1-36.3 |
| アクセシビリティ | 19.1, 19.2 |
| アドボカシー | 38.1-38.2 |
| アンケートウィジェット | 12.4 |
| エスカレーション | 5.1-5.3 |
| エージェント教育 | 20.2 |
| エフォートレス体験 | 1.4, 33.1-33.2 |
| オムニチャネル | 3.1-3.3 |
| オンボーディング | 9.1-9.4 |
| カスタマーサクセス | 7.1-7.3 |
| カスタマージャーニー | 30.1-30.3 |
| コミュニティ | 17.1-17.3 |
| コンテンツモデレーション | 18.2 |
| コンプライアンス | 24.1, 24.2 |
| セルフサービス | 6.1-6.4 |
| チケット管理 | 4.1-4.3 |
| チャーン予兆 | 10.1 |
| ナレッジベース | 6.2, 6.3, 31.1-31.3 |
| ハイパーパーソナライゼーション | 26.1-26.3 |
| パーソナライゼーション | 26.1 |
| フィードバック | 11.1, 11.2 |
| フォーム | 13.1 |
| プロアクティブサポート | 29.1-29.3 |
| メール | 15.1-15.3, 16.1-16.2 |
| リテンション | 10.1-10.3 |
| 多言語サポート | 32.1-32.3 |
| 将来展望 | 39.1-39.2 |
| 技術スタック | 37.1-37.3 |
| 成熟度モデル | 40.1 |
| 更新管理 | 28.3 |
| 権限委譲 | 1.2 |
| 解約フロー | 10.3 |
| 通知 | 14.1-14.5 |

## Appendix B: クロスリファレンス

| 参照先ルール | 関連トピック |
|:-----------|:-----------|
| `000_core_mindset.md` | 優先順位階層、既存機能保護 |
| `100_product_strategy.md` | レビュー・信頼性システム |
| `101_revenue_monetization.md` | AIトークンエコノミクス、FinOps |
| `102_growth_marketing.md` | PLG、オンボーディング、リテンション |
| `200_design_ux.md` | WCAG準拠、おもてなしUX、エラーメッセージ |
| `400_ai_engineering.md` | ガードレール、RAG、PII Scrubbing |
| `401_data_analytics.md` | 分析ダッシュボード品質基準 |
| `500_internal_tools.md` | 管理者エスカレーション基準 |
| `502_site_reliability.md` | インシデント管理、可観測性 |
| `503_incident_response.md` | P0インシデントのエスカレーション、障害コミュニケーション |
| `600_security_privacy.md` | SPF/DKIM/DMARC、ボット防御、プロンプトインジェクション |
| `601_data_governance.md` | GDPR/APPI/CCPA、ダークパターン禁止、子供保護、EU AI Act |
| `700_qa_testing.md` | テスト戦略、アクセシビリティテスト |
| `802_language_protocol.md` | 通知・メール言語プロトコル、多言語対応 |
