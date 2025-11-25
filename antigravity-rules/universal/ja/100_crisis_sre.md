# 100. クライシスマネジメントとSRE (Crisis Management & SRE)

## 1. インシデント対応プロトコル (Incident Response Protocol)
*   **役割分担 (Roles)**:
    *   **コマンダー (Commander)**: 全体の指揮を執り、意思決定を行います。技術的な作業は行いません。
    *   **コミュニケーター (Communicator)**: ユーザーやステークホルダーへの状況報告（Status Page更新、SNS発信）を担当します。
    *   **リゾルバー (Resolver)**: 実際の技術的な調査と修正を行います。
*   **初動 (First Response)**:
    *   **止血 (Stop the Bleeding)**: 原因究明よりも、まず被害の拡大を防ぎます（機能停止、ロールバック）。
    *   **透明性 (Transparency)**: 「調査中」であることを即座にユーザーに伝えます。沈黙は不信感を生みます。

## 2. SRE (Site Reliability Engineering)
*   **SLO/SLI**:
    *   **SLI (Service Level Indicator)**: サービスの健全性を測る指標（例: エラー率、レイテンシ）。
    *   **SLO (Service Level Objective)**: 目標とする水準（例: 可用性 99.9%）。
    *   **SLO (Service Level Objective)**: 目標とする水準（例: 可用性 99.9%）。
    *   **エラーバジェット (Error Budget)**: SLOを超過した場合、新機能の開発を**強制停止**し、信頼性向上（技術的負債の返済）にリソースを100%集中します。これは交渉不可能です。
*   **War Room Protocol**:
    *   **宣言**: 重大インシデント（P0）発生時は、即座に「War Room（専用通話チャンネル）」を開設し、解決するまで全員がそこに常駐します。
    *   **記録**: 全ての会話と決定事項をタイムラインとして記録し、後のポストモーテムで使用します。
*   **ポストモーテム (Post-Mortem)**:
    *   **非難なし (Blameless)**: 「誰が悪かったか」ではなく「何が起きたか」「なぜ起きたか」「どうすれば再発を防げるか」を議論します。
    *   **ドキュメント化**: 事故報告書を作成し、全社で共有します。

## 3. バックアップと復旧 (Backup & Recovery)
*   **RPO/RTO**:
    *   **RPO (Recovery Point Objective)**: どの時点までデータを復旧できるか（例: 1時間前）。
    *   **RTO (Recovery Time Objective)**: 復旧までに許容される時間（例: 4時間以内）。
*   **訓練 (Drills)**:
    *   定期的に避難訓練（Disaster Recovery Drill）を行い、バックアップから実際に復旧できるか確認します。
*   **Playbooks**:
    *   「DBが消えた時」「APIがダウンした時」などの具体的な対応手順書（Playbook）を事前に用意します。
